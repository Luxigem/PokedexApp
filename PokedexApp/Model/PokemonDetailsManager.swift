//
//  PokemonDetailsManager.swift
//  PokedexApp
//
//  Created by Miguel on 10/17/22.
//

import Foundation

protocol PokemonDetailsManagerDelegate {
    func didObtainPokemonDescription(pokemonDescriptionModel: PokemonDescriptionModel)
    func didObtainPokemonAbilities(pokemonAbilitiesModel: PokemonAbilitiesModel)
    func didFailWithError(error: Error)
}

struct PokemonDetailsManager {
    
    var delegate: PokemonDetailsManagerDelegate?
    
    func performRequestDespription(id: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(id)/"
        if let url: URL = URL(string: urlString) {
            let session: URLSession = URLSession(configuration: .default)
            let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData: Data = data {
                    if let details: PokemonDescriptionModel = self.parseDescriptionJSON(safeData) {
                        self.delegate?.didObtainPokemonDescription(pokemonDescriptionModel: details)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performRequestAbilities(id: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)/"
        if let url: URL = URL(string: urlString) {
            let session: URLSession = URLSession(configuration: .default)
            let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData: Data = data {
                    if let details: PokemonAbilitiesModel = self.parseAbilitiesJSON(pokemonAbilitiesData: safeData) {
                        self.delegate?.didObtainPokemonAbilities(pokemonAbilitiesModel: details)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseDescriptionJSON(_ pokemonDescriptionData: Data) -> PokemonDescriptionModel? {
        var detailsOfThePokemon: PokemonDescriptionModel?
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let decodedData: PokemonDescriptionInformation = try decoder.decode(PokemonDescriptionInformation.self, from: pokemonDescriptionData)
            
            detailsOfThePokemon = PokemonDescriptionModel(
                pokemonDetails: decodedData.flavor_text_entries?.first(where: { $0.language?.name == "en" })?.flavor_text
            )
            return detailsOfThePokemon
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseAbilitiesJSON(pokemonAbilitiesData: Data) -> PokemonAbilitiesModel? {
        var abilitiesOfThePokemon: PokemonAbilitiesModel?
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let decodedData: PokemonAbilitiesInformation = try decoder.decode(PokemonAbilitiesInformation.self, from: pokemonAbilitiesData)
            
            abilitiesOfThePokemon = PokemonAbilitiesModel(
                pokemonAbility1: decodedData.abilities?.first(where: {$0.slot == 1})?.ability?.name,
                pokemonAbility2: decodedData.abilities?.first(where: {$0.slot == 2})?.ability?.name,
                pokemonHiddenAbility: decodedData.abilities?.first(where: {$0.slot == 3})?.ability?.name
            )
            return abilitiesOfThePokemon
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
