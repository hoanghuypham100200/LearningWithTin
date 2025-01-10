//
//  PokemonViewModel.swift
//  LearningWithTin
//
//  Created by Huy on 10/1/25.
//
import Alamofire

class PokemonViewModel {
    private var pokemons: [Pokemon] = []
    private var pokemonsDetail: PokemonDetail?
    private var apiUrl = "https://pokeapi.co/api/v2/pokemon"

    var reloadTableView: (() -> Void)?
    var updateView: (() -> Void)?
    
    func fetchPokemons() {
        AF.request(apiUrl).responseDecodable(of: PokemonResponse.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.pokemons = data.results
                DispatchQueue.main.async {
                    self?.reloadTableView?()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    self?.updateView?()
                }
            }
        }
    }
    func fetchPokemonById(id: Int) {
        let apiUrlById = "https://pokeapi.co/api/v2/pokemon/\(id)"
        AF.request(apiUrlById).responseDecodable(of: PokemonDetail.self) { [weak self] response in
            switch response.result {
            case .success(let pokemonDetail):
                self?.pokemonsDetail = pokemonDetail
                DispatchQueue.main.async {
                    self?.updateView?()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    func getPokemonName() ->String {
        return pokemonsDetail?.name ?? "Loading..."
    }
    
    func getAbilities() -> String {
           let abilities = pokemonsDetail?.abilities.map { $0.ability.name }.joined(separator: ", ") ?? "Loading..."
           return "Abilities: \(abilities)"
    }
   
    func getTypes() -> String {
        let types = pokemonsDetail?.types.map { $0.type.name }.joined(separator: ", ") ?? "Loading..."
           return "Types: \(types)"
    }
    func getStats() -> [(name: String, value: Int)] {
        return pokemonsDetail?.stats.map {
            return (name: $0.stat.name, value: $0.base_stat)
        } ?? []
    }

    func numberOfRows() -> Int {
        return pokemons.count
    }

    func pokemonName(at index: Int) -> String {
        return pokemons[index].name
    }
    func getSpriteURL() -> String? {
          return pokemonsDetail?.sprites.front_default
    }
}

