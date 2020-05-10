//
//  PokemonManager.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 7/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

typealias DownloadCompletedPokemonBase = (_ result: [SPokemonBase]?) -> Void

protocol PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, sPokemons: [SPokemon])
    func didFailWithError(error: Error)
}

class PokemonManager {
    
    let pokemonUrl: String = "https://pokeapi.co/api/v2/pokemon/"
    
    var delegate: PokemonManagerDelegate?
    
    var sPokemonsBase = [SPokemonBase]()
    var sPokemons = [SPokemon]()
    
    // MARK: - Extrae todos los datos base de todos los pokemón de acuerdo al límite establecido.
    func fetchAllPokemonBase(limit: Int = 30) {
        print("Entra al fetchAllPokemonBase...")
        let DATA_LOCAL_ISVALID = UserDefaults.standard.bool(forKey: "DATA_LOCAL_ISVALID")
        if DATA_LOCAL_ISVALID {
            self.sPokemons = (DataTransaction.shared.getAllPokemon())!
            if self.sPokemons.count > 0 {
                UserDefaults.standard.set(true, forKey: "DATA_LOCAL_ISVALID")
                self.delegate?.didUpdatePokemon(self, sPokemons: self.sPokemons)
                return
            } else {
                UserDefaults.standard.set(false, forKey: "DATA_LOCAL_ISVALID")
            }
        }
        let urlString: String = pokemonUrl + String(format: "?limit=\(limit)&offset=0")
        
        print("No hay datos locales, se tomará como fuente la URL base: \(urlString)")
        
        self.performFetchAllOfPokemonBase(urlString: urlString, completed: { pokemonsBase -> Void in
            self.sPokemonsBase = pokemonsBase!
        })
        self.sPokemons = (DataTransaction.shared.getAllPokemon())!
        //print("\(self.sPokemons)")
        if self.sPokemons.count > 0 {
            UserDefaults.standard.set(true, forKey: "DATA_LOCAL_ISVALID")
            self.delegate?.didUpdatePokemon(self, sPokemons: self.sPokemons)
        }
    }
    
    // MARK: - Realiza la petición al API del sitio pokeapi.co para extraer la lista base de pokemons.
    func performFetchAllOfPokemonBase(urlString: String, completed: @escaping DownloadCompletedPokemonBase) {
        var pokemonsBase = [SPokemonBase]()
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                print("Inicia la tarea de descaga de la data.")
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let sPokemonsBase = self.parseJSONPokemonBase(data: safeData) {
                        pokemonsBase = sPokemonsBase
                        // Se almacena la base de pokemon (nombre y url) en el esquema de datos.
                        for pBase in sPokemonsBase {
                            _ = DataTransaction.shared.save(sPokemonBase: pBase)
                            self.performFetchPokemonData(urlString: pBase.url)
                        }
                    }
                    // Marca que la base se encuentra local.
                    UserDefaults.standard.set(true, forKey: "DATA_LOCAL_ISVALID")
                    completed(pokemonsBase)
                    print("Termina la tarea de descaga de la data.")
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Parsea la data base de la lista de pokemons por nombre y url individual y la convierte en un arreglo SPokemonBase
    func parseJSONPokemonBase(data: Data?) -> [SPokemonBase]? {
        // create json object from data
        var pokemonBase: SPokemonBase?
        var pokemonsBase = [SPokemonBase]()
        let jsonDecoded = try! JSONDecoder().decode(SResponse.self, from: data!)
        for result in jsonDecoded.results! {
            let name = result.name!
            let url = result.url!
            pokemonBase = SPokemonBase(name: name, url: url)
            //print("Pokemon name: \(pokemonBase?.name!) Pokemon URL: \(pokemonBase?.url!)")
            pokemonsBase.append(pokemonBase!)
        }
        return pokemonsBase
    }
    
    // MARK: - Realiza la petición al API del sitio pokeapi.co para extraer la lista sprites, types, moves e items.
    func performFetchPokemonData(urlString: String) {
        if let url = URL(string: urlString) {
            //print("URL for fetching all data: \(urlString)")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let sPokemon = self.parseJSONPokemon(data: safeData) {
                        DispatchQueue.main.async {
                            if let imageDataURL = sPokemon.sprites?.front_default {
                                if imageDataURL != "" {
                                    let imageData = URL.init(string: imageDataURL)
                                    do {
                                        let dataImage: Data = try Data.init(contentsOf: imageData!)
                                        sPokemon.image_url  = saveImageIn(directory: "images", data: dataImage)
                                    } catch {
                                        print("Error downloading image for \(sPokemon.name!).    \(error.localizedDescription)")
                                    }
                                }
                            }
                            // Se guardan los datos del pokemón en el esquema de datos local.
                            _ = DataTransaction.shared.save(sPokemon: sPokemon)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    // MARK: - Parsea la data de un pokemon y la convierte en un SPokemon.
    func parseJSONPokemon(data: Data?) -> SPokemon? {
        // create json object from data
        var sPokemon: SPokemon?
        let jsonDecoded = try! JSONDecoder().decode(SPokemon.self, from: data!)
        sPokemon = jsonDecoded
        return sPokemon
    }
}
