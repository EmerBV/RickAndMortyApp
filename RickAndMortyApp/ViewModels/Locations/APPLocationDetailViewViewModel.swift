//
//  APPLocationDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

protocol APPLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class APPLocationDetailViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (location: APPLocation, characters: [APPCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }

    enum SectionType {
        case information(viewModels: [APPEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [APPCharacterCollectionViewCellViewModel])
    }

    public weak var delegate: APPLocationDetailViewViewModelDelegate?

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

        let location = dataTuple.location
        let characters = dataTuple.characters

        var createdString = location.created
        if let date = APPCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = APPCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
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
    public func fetchLocationData() {
        guard let url = endpointUrl,
              let request = APPRequest(url: url) else {
            return
        }

        APPService.shared.execute(request,
                                 expecting: APPLocation.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
            case .failure:
                break
            }
        }
    }

    private func fetchRelatedCharacters(location: APPLocation) {
        let requests: [APPRequest] = location.residents.compactMap({
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
                location: location,
                characters: characters
            )
        }
    }
}

