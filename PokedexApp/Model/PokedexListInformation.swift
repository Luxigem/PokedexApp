//
//  PokedexListInformation.swift
//  PokedexApp
//
//  Created by Miguel on 10/17/22.
//

import Foundation

struct PokedexListInformation: Codable {
    let results: [Results]?
}

struct Results: Codable {
    let name: String?
}
