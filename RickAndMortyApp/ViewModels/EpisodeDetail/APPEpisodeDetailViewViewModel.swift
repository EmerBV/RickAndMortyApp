//
//  APPEpisodeDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

protocol APPEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class APPEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (episode: APPEpisode, characters: [APPCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }

    enum SectionType {
        case information(viewModels: [APPEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [APPCharacterCollectionViewCellViewModel])
    }

    public weak var delegate: APPEpisodeDetailViewViewModelDelegate?

    public private(set) var cellViewModels: [SectionType] = []

    // MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }

    public func character(at index: Int) -> APPCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }

    // MARK: - Private

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }

        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = episode.created
        if let date = APPCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = APPCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return APPCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }

    ///
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = APPRequest(url: url) else {
            return
        }

        APPService.shared.execute(request,
                                 expecting: APPEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }

    private func fetchRelatedCharacters(episode: APPEpisode) {
        let requests: [APPRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return APPRequest(url: $0)
        })

        let group = DispatchGroup()
        var characters: [APPCharacter] = []
        for request in requests {
            group.enter()
            APPService.shared.execute(request, expecting: APPCharacter.self) { result in
                defer {
                    group.leave()
                }

                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
}
