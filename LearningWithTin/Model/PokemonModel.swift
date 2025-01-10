import Foundation

// Model
struct Pokemon: Codable {
    let name: String
    let url: String
}

// Response
struct PokemonResponse: Codable {
    let results: [Pokemon]
}

struct PokemonDetail: Codable {
    let name: String
    let id: Int
    let abilities: [Ability]
    let sprites: Sprites
    let types: [TypePokemon]
    let stats: [Stat]
}
struct Stat: Codable {
    let base_stat: Int
    let stat: StatDetail
}
struct StatDetail: Codable {
    let name: String
}
struct TypePokemon: Codable {
    let type: TypeDetail
}
struct TypeDetail: Codable {
    let name: String
    let url: String
}

struct Ability: Codable {
    let ability: AbilityDetail
}
struct AbilityDetail: Codable {
    let name: String
}
struct Sprites: Codable {
    let front_default: String?
    let back_default: String?
}



