//
//  APPSearchViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import UIKit

final class APPSearchViewViewModel {
    let config: APPSearchViewController.Config
    private var optionMap: [APPSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""

    private var optionMapUpdateBlock: (((APPSearchInputViewViewModel.DynamicOption, String)) -> Void)?

    private var searchResultHandler: ((APPSearchResultViewModel) -> Void)?

    private var noResultsHandler: (() -> Void)?

    private var searchResultModel: Codable?

    // MARK: - Init

    init(config: APPSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func registerSearchResultHandler(_ block: @escaping (APPSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }

    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }

    public func executeSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: APPSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))

        // Create request
        let request = APPRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )

        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(APPGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(APPGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(APPGetAllLocationsResponse.self, request: request)
        }
    }

    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: APPRequest) {
        APPService.shared.execute(request, expecting: type) { [weak self] result in
            // Notify view of results, no results, or error

            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }

    private func processSearchResults(model: Codable) {
        var resultsVM: APPSearchResultType?
        var nextUrl: String?
        if let characterResults = model as? APPGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return APPCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            }))
            nextUrl = characterResults.info.next
        }
        else if let episodesResults = model as? APPGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap({
                return APPCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )
            }))
            nextUrl = episodesResults.info.next
        }
        else if let locationsResults = model as? APPGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                return APPLocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationsResults.info.next
        }

        if let results = resultsVM {
            self.searchResultModel = model
            let vm = APPSearchResultViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(vm)
        } else {
            // fallback error
            handleNoResults()
        }
    }

    private func handleNoResults() {
        noResultsHandler?()
    }

    public func set(query text: String) {
        self.searchText = text
    }

    public func set(value: String, for option: APPSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(
        _ block: @escaping ((APPSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }

    public func locationSearchResult(at index: Int) -> APPLocation? {
        guard let searchModel = searchResultModel as? APPGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }

    public func characterSearchResult(at index: Int) -> APPCharacter? {
        guard let searchModel = searchResultModel as? APPGetAllCharactersResponse else {
            return nil
        }
        return searchModel.results[index]
    }

    public func episodeSearchResult(at index: Int) -> APPEpisode? {
        guard let searchModel = searchResultModel as? APPGetAllEpisodesResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}
