//
//  Pokemon.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 7.10.2025.
//
import UIKit

struct Pokemon: Decodable {
    var name: String
    var id: Int
    var sprites: Sprites
}
struct Sprites: Decodable {
    var frontDefault: String
    var backDefault: String
}
