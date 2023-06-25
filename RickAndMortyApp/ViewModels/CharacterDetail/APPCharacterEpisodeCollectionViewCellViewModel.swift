//
//  APPCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

protocol APPEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class APPCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {

    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((APPEpisodeDataRender) -> Void)?

    public let borderColor: UIColor

    private var episode: APPEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }

    // MARK: - Init

    init(episodeDataUrl: URL?, borderColor: UIColor = UIColor(named: "RickAndMortyBlue") ?? .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }

    // MARK: - Public

    public func registerForData(_ block: @escaping (APPEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }

    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }

        guard let url = episodeDataUrl,
              let request = APPRequest(url: url) else {
            return
        }

        isFetching = true

        APPService.shared.execute(request, expecting: APPEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }

    static func == (lhs: APPCharacterEpisodeCollectionViewCellViewModel, rhs: APPCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
