//
//  APPCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import Foundation

final class APPCharacterPhotoCollectionViewCellViewModel {
    private let imageUrl: URL?

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        APPImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}

