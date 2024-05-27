//
//  PokemanNetwork.swift
//  PokemanList
//
//  Created by Nikita on 27/05/24.
//

import Foundation

class PokemonService {
    static let shared = PokemonService()
    private let baseURL = "https://pokeapi.co/api/v2"
    private let session = URLSession.shared

    //API Calling for fetching the list of pokeman with Offset for the pagination concept
    func fetchPokemonList(limit: Int, offset: Int, completion: @escaping (Result<PokemonListResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/pokemon?limit=\(limit)&offset=\(offset)")!
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "dataNilError", code: -1001, userInfo: nil)))
                return
            }
            do {
                let listResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completion(.success(listResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    //API Calling for fetching the detail of single pokeman
    func fetchPokemonDetail(url: String, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "dataNilError", code: -1001, userInfo: nil)))
                return
            }
            do {
                let detailResponse = try JSONDecoder().decode(PokemonDetail.self, from: data)
                completion(.success(detailResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
