//
//  APPLocationTableViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

struct APPLocationTableViewCellViewModel: Hashable, Equatable {

    private let location: APPLocation

    init(location: APPLocation) {
        self.location = location
    }

    public var name: String {
        return location.name
    }

    public var type: String {
        return "Type: "+location.type
    }

    public var dimension: String {
        return location.dimension
    }

    static func == (lhs: APPLocationTableViewCellViewModel, rhs: APPLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}
