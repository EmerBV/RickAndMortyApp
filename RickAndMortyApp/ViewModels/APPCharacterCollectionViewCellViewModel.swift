//
//  APPCharacterCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

final class APPCharacterCollectionViewCellViewModel: Hashable, Equatable {
    public let characterName: String
    private let characterStatus: APPCharacterStatus
    private let characterImageUrl: URL?

    // MARK: - Init

    init(
        characterName: String,
        characterStatus: APPCharacterStatus,
        characterImageUrl: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }

    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        APPImageLoader.shared.downloadImage(url, completion: completion)
    }

    // MARK: - Hashable

    static func == (lhs: APPCharacterCollectionViewCellViewModel, rhs: APPCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
