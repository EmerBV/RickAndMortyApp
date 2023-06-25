//
//  APPSearchResultViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

final class APPSearchResultViewModel {
    public private(set) var results: APPSearchResultType
    private var next: String?

    init(results: APPSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }

    public private(set) var isLoadingMoreResults = false

    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }

    public func fetchAdditionalLocations(completion: @escaping ([APPLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }

        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreResults = true

        guard let request = APPRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }

        APPService.shared.execute(request, expecting: APPGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next // Capture new pagination url

                let additionalLocations = moreResults.compactMap({
                    return APPLocationTableViewCellViewModel(location: $0)
                })
                var newResults: [APPLocationTableViewCellViewModel] = []

                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                case .characters, .episodes:
                    break
                }

                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false

                    // Notify via callback
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreResults = false
            }
        }
    }

    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }

        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreResults = true

        guard let request = APPRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }

        switch results {
        case .characters(let existingResults):
            APPService.shared.execute(request, expecting: APPGetAllCharactersResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next // Capture new pagination url

                    let additionalResults = moreResults.compactMap({
                        return APPCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image))
                    })
                    var newResults: [APPCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    strongSelf.results = .characters(newResults)

                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false

                        // Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .episodes(let existingResults):
            APPService.shared.execute(request, expecting: APPGetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next // Capture new pagination url

                    let additionalResults = moreResults.compactMap({
                        return APPCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    var newResults: [APPCharacterEpisodeCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    strongSelf.results = .episodes(newResults)

                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false

                        // Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations:
            // TableView case
            break
        }


    }
}

enum APPSearchResultType {
    case characters([APPCharacterCollectionViewCellViewModel])
    case episodes([APPCharacterEpisodeCollectionViewCellViewModel])
    case locations([APPLocationTableViewCellViewModel])
}
