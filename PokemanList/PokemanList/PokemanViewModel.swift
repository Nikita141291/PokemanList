//
//  PokemanViewModel.swift
//  PokemanList
//
//  Created by Nikita on 27/05/24.
//

import SwiftUI
import Combine

class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var sortedBy: SortOption = .id
    @Published var isLoading = false
    @Published var error: Error?

    private var currentPage = 0
    private let limit = 100
    private var cancellables = Set<AnyCancellable>()

    enum SortOption {
        case id, name
    }

    init() {
        loadPokemon()
    }
    //Initally Load the Pokeman
    func loadPokemon() {
        guard !isLoading else { return }
        isLoading = true
        PokemonService.shared.fetchPokemonList(limit: limit, offset: currentPage * limit) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.pokemonList.append(contentsOf: response.results)
                    self.currentPage += 1 //Page inc for the pagination concept
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }

    func sortPokemon(by option: SortOption) {
        sortedBy = option
        switch option {
        case .id:
            pokemonList.sort { $0.pokemonID < $1.pokemonID } //sort by ID
        case .name:
            pokemonList.sort { $0.name < $1.name } // sort by Name
        }
    }
}

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    @Published var isLoading = false
    @Published var error: Error?

    //Load the Pokeman detail
    func loadDetail(for url: String) {
        guard !isLoading else { return }
        isLoading = true
        PokemonService.shared.fetchPokemonDetail(url: url) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let detail):
                    self.pokemonDetail = detail
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}
