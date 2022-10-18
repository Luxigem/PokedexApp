//
//  PokemonDetailsInformation.swift
//  PokedexApp
//
//  Created by Miguel on 10/17/22.
//

import Foundation

struct PokemonDescriptionInformation: Codable {
    let flavor_text_entries: [FlavorTextEntries]?
}

struct PokemonAbilitiesInformation: Codable {
    let abilities: [Abilities]?
}

struct FlavorTextEntries: Codable {
    let flavor_text: String?
    let language: Language?
}

struct Language: Codable {
    let name: String?
}

struct Abilities: Codable {
    let ability: Ability?
    let is_hidden: Bool?
    let slot: Int?
}

struct Ability: Codable {
    let name: String?
}
