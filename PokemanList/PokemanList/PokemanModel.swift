//
//  PokemanModel.swift
//  PokemanList
//
//  Created by Nikita on 27/05/24.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [Pokemon]
    let next: String?
}

struct Pokemon: Codable, Identifiable {
    let id: UUID = UUID() // Use a UUID to uniquely identify list items
    let name: String
    let url: String

    var pokemonID: Int {
        let components = url.split(separator: "/")
        return Int(components[components.count - 1]) ?? -1
    }
}

struct PokemonDetail: Codable {
    let id: Int
      let name: String
      let base_experience: Int
      let abilities: [Ability]
      let sprites: Sprites

      struct Ability: Codable {
          let ability: AbilityDetail

          struct AbilityDetail: Codable {
              let name: String
          }
      }

      struct Sprites: Codable {
          let front_default: String
      }
}
