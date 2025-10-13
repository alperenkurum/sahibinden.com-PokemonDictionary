//
//  PokemonDetailn.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 8.10.2025.
//

import UIKit

struct PokemonDetail: Decodable{
    var id: Int
    var name: String
    var sprites: Sprites
    var weight: Int
    var height: Int
    var abilities: [Ability]
}

struct Ability: Decodable{
    var ability: AbilityDetail
    var isHidden: Bool
}

struct AbilityDetail: Decodable{
    var name: String
}
