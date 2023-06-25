//
//  APPCharacter.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import Foundation

struct APPCharacter: Codable {
    let id: Int
    let name: String
    let status: APPCharacterStatus
    let species: String
    let type: String
    let gender: APPCharacterGender
    let origin: APPOrigin
    let location: APPSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
