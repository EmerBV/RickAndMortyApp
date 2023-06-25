//
//  APPSettingsCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

struct APPSettingsCellViewModel: Identifiable {
    let id = UUID()

    public let type: APPSettingsOption
    public let onTapHandler: (APPSettingsOption) -> Void

    // MARK: - Init

    init(type: APPSettingsOption, onTapHandler: @escaping (APPSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }

    // MARK: - Public

    public var image: UIImage? {
        return type.iconImage
    }

    public var title: String {
        return type.displayTitle
    }

    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
