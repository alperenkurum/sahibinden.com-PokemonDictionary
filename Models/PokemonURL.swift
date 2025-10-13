//
//  pokemonURL.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 7.10.2025.
//

import UIKit

struct PokemonURL: Decodable {
    var results: [Results]
}
struct Results: Decodable {
    var name: String
    var url: String
}
