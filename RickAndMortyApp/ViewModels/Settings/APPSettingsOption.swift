//
//  APPSettingsOption.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

enum APPSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode

    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://www.linkedin.com/in/emerson-balahan")
        case .terms:
            return URL(string: "https://policies.warnerbros.com/terms/en-us/html/terms_en-us_1.3.0.html")
        case .privacy:
            return URL(string: "https://www.warnermediaprivacy.com/policycenter/b2c/wm")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation")
        case .viewSeries:
            return URL(string: "https://www.hbomax.com/es/es/series/urn:hbo:series:GXkRjxwjR68PDwwEAABKJ")
        case .viewCode:
            return URL(string: "https://github.com/EmerBV/RickAndMortyApp")
        }
    }

    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View VIdeo Series"
        case .viewCode:
            return "View App Code"
        }
    }

    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return UIColor(named: "RickAndMortyBlue") ?? .systemBlue
        case .contactUs:
            return UIColor(named: "RickAndMortyGreen") ?? .systemGreen
        case .terms:
            return UIColor(named: "RickAndMortyRed") ?? .systemRed
        case .privacy:
            return UIColor(named: "RickAndMortyYellow") ?? .systemYellow
        case .apiReference:
            return UIColor(named: "RickAndMortyOrange") ?? .systemOrange
        case .viewSeries:
            return UIColor(named: "RickAndMortyPurple") ?? .systemPurple
        case .viewCode:
            return UIColor(named: "RickAndMortyPink") ?? .systemPink
        }
    }

    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
