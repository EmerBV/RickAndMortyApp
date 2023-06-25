//
//  APPCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

final class APPCharacterInfoCollectionViewCellViewModel {
    private let type: `Type`
    private let value: String

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()

    public var title: String {
        type.displayTitle
    }

    public var displayValue: String {
        if value.isEmpty { return "None" }

        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }

        return value
    }

    public var iconImage: UIImage? {
        return type.iconImage
    }

    public var tintColor: UIColor {
        return type.tintColor
    }

    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount

        var tintColor: UIColor {
            switch self {
            case .status:
                return UIColor(named: "RickAndMortyBlue") ?? .systemBlue
            case .gender:
                return UIColor(named: "RickAndMortyRed") ?? .systemRed
            case .type:
                return UIColor(named: "RickAndMortyPurple") ?? .systemPurple
            case .species:
                return UIColor(named: "RickAndMortyGreen") ?? .systemGreen
            case .origin:
                return UIColor(named: "RickAndMortyOrange") ?? .systemOrange
            case .created:
                return UIColor(named: "RickAndMortyPink") ?? .systemPink
            case .location:
                return UIColor(named: "RickAndMortyYellow") ?? .systemYellow
            case .episodeCount:
                return UIColor(named: "RickAndMortyMint") ?? .systemMint
            }
        }

        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(named: "status")
            case .gender:
                return UIImage(named: "gender")
            case .type:
                return UIImage(named: "type")
            case .species:
                return UIImage(named: "morty")
            case .origin:
                return UIImage(systemName: "person.and.background.dotted")
            case .created:
                return UIImage(systemName: "calendar.badge.clock")
            case .location:
                return UIImage(named: "dimension")
            case .episodeCount:
                return UIImage(systemName: "text.insert")
            }
        }

        var displayTitle: String {
            switch self {
            case .status,
                .gender,
                .type,
                .species,
                .origin,
                .created,
                .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }

    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
