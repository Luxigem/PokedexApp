//
//  PokedexListManager.swift
//  PokedexApp
//
//  Created by Miguel on 10/17/22.
//

import Foundation

protocol PokedexListManagerDelegate {
    func didObtainPokedexList(pokedexList: [PokedexListModel])
    func didFailWithError(error: Error)
}

struct PokedexListManager {
    let urlString: String = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=151"
    
    var delegate: PokedexListManagerDelegate?
    
    func performRequest(){
        if let url: URL = URL(string: urlString) {
            let session: URLSession = URLSession(configuration: .default)
            let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData: Data = data,
                   let pokedex: [PokedexListModel] = self.parseJSON(safeData) {
                    self.delegate?.didObtainPokedexList(pokedexList: pokedex)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ pokedexData: Data) -> [PokedexListModel]? {
        var arrayPokedexListModel: [PokedexListModel] = []
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let decodedData: PokedexListInformation = try decoder.decode(PokedexListInformation.self, from: pokedexData)
            let responseArray: [Results] = decodedData.results ?? []
            var idCount: Int = 0
            for pokemon in responseArray {
                let name = pokemon.name
                idCount += 1
                
                arrayPokedexListModel.append(PokedexListModel(
                    pokemonName: name,
                    pokemonId: idCount
                ))}
            return arrayPokedexListModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
