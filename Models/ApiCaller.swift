//
//  ApiCalls.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 7.10.2025.
//
import UIKit

class ApiCaller{
    var currentPage: Int = 0
    var isLoading: Bool = false // burayi sil
    func getPokemonURLs(Limit pageLimit: Int = 20) async throws -> PokemonURL {
        isLoading.toggle()
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=\(pageLimit)&offset=\(currentPage*pageLimit)"
        guard let url = URL(string: endpoint) else {
            fatalError("Invalid URL")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            fatalError("EROR")
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            currentPage+=1
            return try decoder.decode(PokemonURL.self, from: data)
        }catch (let error){
            
            fatalError("Invalid data")
        }
    }
    
    func getPokemonDatas(URLs urlList: PokemonURL) async throws -> [Pokemon] {
        var pokemonList: [Pokemon] = []
        
        for pokemonUrl in urlList.results {
            pokemonList.append(try await getFrontPokemonData(URL: pokemonUrl.url))
        }
        return pokemonList
    }
    
    func getFrontPokemonData(URL endpoint: String) async throws -> Pokemon {
        guard let url = URL(string: endpoint) else {
            fatalError("Invalid URL")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            fatalError("EROR")
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Pokemon.self, from: data)
        }catch {
            print(" Unexpected error: \(error)")
            fatalError()
        }
    }
    
    func getImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            fatalError("EROR")
        }
        guard let image = UIImage(data: data) else {
            fatalError("Invalid URL")
        }
        return image
    }
    
    func getPokemonDetails(ID id: Int) async throws -> PokemonDetail {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)/"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            fatalError("EROR")
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PokemonDetail.self, from: data)
        } catch {
            print(error)
            fatalError("EROR")
        }
    }
}
