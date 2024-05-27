//
//  ContentView.swift
//  PokemanList
//
//  Created by Nikita on 27/05/24.
//

import SwiftUI
extension PokemonService //Here i had created the extension for the caching concept.
{
    private var cacheKey: String { "pokemonListCache" }
    
    func cachePokemonList(_ list: [Pokemon]) {
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }

    func loadCachedPokemonList() -> [Pokemon]? {
        if let savedData = UserDefaults.standard.data(forKey: cacheKey),
           let decodedList = try? JSONDecoder().decode([Pokemon].self, from: savedData) {
            return decodedList
        }
        return nil
    }
}

struct ContentView: View
{
    @StateObject private var listViewModel = PokemonListViewModel()
    @State private var selectedPokemon: Pokemon?

    var body: some View {
        NavigationSplitView {
            VStack {
                Picker("Sort by", selection: $listViewModel.sortedBy) {
                    Text("ID").tag(PokemonListViewModel.SortOption.id)
                    Text("Name").tag(PokemonListViewModel.SortOption.name)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(listViewModel.pokemonList) { pokemon in
                    NavigationLink {
                        PokemonDetailView(pokemon: pokemon)
                    } label:{
                        Text(pokemon.name.capitalized)
                    }
                }
            }
            .onChange(of: listViewModel.sortedBy, { oldValue, newValue in
                listViewModel.sortPokemon(by: newValue)
            })
            .navigationTitle("Pokémon")
        } detail: {
            if let selectedPokemon = selectedPokemon {
                PokemonDetailView(pokemon: selectedPokemon)
            } else {
                Text("Select a Pokémon")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct LabeledText: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
            Text(value)
        }
    }
}
struct PokemonDetailView: View {
    let pokemon: Pokemon
    @StateObject private var detailViewModel = PokemonDetailViewModel()

    var body: some View {
        VStack {
            if let detail = detailViewModel.pokemonDetail
            {
                VStack(alignment: .leading, spacing: 10)
                {
                    if let imageUrl = URL(string: detail.sprites.front_default)
                    {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 40))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.white, lineWidth: 4)
                                    )
                                    .shadow(color: .gray, radius: 10, x: 0, y: 10)
                            case .failure:
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.red)
                            @unknown default:
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        Text("Invalid URL")
                    }
                    Text(detail.name.capitalized).font(.title2)
                    LabeledText(label: "ID:", value: "\(detail.id)")
                    LabeledText(label: "Base Experience:", value: "\(detail.id)")
                    LabeledText(label: "Abilities:", value: "")
                    ForEach(detail.abilities, id: \.ability.name) { ability in
                        Text(ability.ability.name)
                    }
                    Spacer()
                }
                .padding()
            } else if detailViewModel.isLoading {
                ProgressView()
            } else if let error = detailViewModel.error {
                Text("Error: \(error.localizedDescription)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            detailViewModel.loadDetail(for: pokemon.url)
        }
        //.navigationTitle(pokemon.name.capitalized)
    }
}
