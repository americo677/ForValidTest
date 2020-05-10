//
//  DataTransaction.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class DataTransaction {
    static let shared = DataTransaction()
    
    private init() { }

    // MARK: - Extrae todas las filas
    func fetchData(entity: ClassModel, byIndex index: Double? = nil, orderByIndex order: Bool? = false) -> [AnyObject] {
        
        var results = [AnyObject]()
        
        let moc = SingleManagedObjectContext.shared.getMOC()
        
        switch entity {
            case .pokemon:
                let fetchPokemon: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
                fetchPokemon.entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: moc)
                do {
                    results = try moc.fetch(fetchPokemon)
                } catch {
                    print(error)
                }
                break
            case .pokemon_base:
            let fetchPokemonBase: NSFetchRequest<PokemonBase> = PokemonBase.fetchRequest()
            fetchPokemonBase.entity = NSEntityDescription.entity(forEntityName: "PokemonBase", in: moc)
            if index != nil {
                let predicate = NSPredicate(format: " indice == %d ", (index! as NSNumber).intValue)

                fetchPokemonBase.predicate = predicate
            }
            do {
                results = try moc.fetch(fetchPokemonBase)
            } catch {
                print(error)
            }
            break
        }
        
        return results
    }
    
    // MARK: - Extrae un pokemon de tipo NSManagedObject del esquema de datos local filtrado por su atributo name.
    func fetchSinglePokemonDataFrom(entity: ClassModel, byName name: String) -> PokemonBase? {
        var results = [AnyObject]()
        var result: PokemonBase? = nil
        let moc = SingleManagedObjectContext.shared.getMOC()
        switch entity {
            case .pokemon:
                let fetchPokemonBase: NSFetchRequest<PokemonBase> = PokemonBase.fetchRequest()
                fetchPokemonBase.entity = NSEntityDescription.entity(forEntityName: "PokemonBase", in: moc)
                let predicate = NSPredicate(format: " name == %s ", name)
                fetchPokemonBase.predicate = predicate
                do {
                    results = try moc.fetch(fetchPokemonBase)
                } catch {
                    print(error)
                }
                break
            case .pokemon_base:
                break
        }
        if (results.count) > 0 {
            result = (results.first as! PokemonBase)
        }
        return result
    }

    // MARK: - Extrae todos los elementos PokemonBase almacenados en el esquema de datos.
    func getAllPokemonBase() -> [SPokemonBase]? {
        
        let moc = SingleManagedObjectContext.shared.getMOC()
        var resultFetched = [AnyObject]()
        var results = [SPokemonBase]()

        let fetchPokemon: NSFetchRequest<PokemonBase> = PokemonBase.fetchRequest()
        fetchPokemon.entity = NSEntityDescription.entity(forEntityName: "PokemonBase", in: moc)
        do {
            resultFetched = try moc.fetch(fetchPokemon)
            for result in resultFetched {
                let name = (result as! PokemonBase).name! as String
                let url = (result as! PokemonBase).url! as String
                let pokemon = SPokemonBase(name: name , url: url)
                results.append(pokemon as SPokemonBase)
            }
        } catch {
            print(error)
        }
        return results
    }
    
    // MARK: - Extrae todos los elementos Pokemon almacenados en el esquema de datos.
    func getAllPokemon() -> [SPokemon]? {
        
        let moc = SingleManagedObjectContext.shared.getMOC()
        var resultFetched = [AnyObject]()
        var results = [SPokemon]()

        let fetchPokemon: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchPokemon.entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: moc)
        //let predicate = NSPredicate(format: " name == %s ", name)
        //fetchPokemonBase.predicate = predicate
        do {
            resultFetched = try moc.fetch(fetchPokemon)
            for result in resultFetched {
                let object_id: Int16 = (result as! Pokemon).object_id as Int16
                let name = result.name as String
                var front_default: String?
                if let fd = result.front_default! {
                    front_default = fd
                }
                var image_url: String?
                if let img_url = (result as! Pokemon).image_url {
                    image_url = img_url
                }
                let sprites = SSprite(front_default: front_default)
                var types = [SType]()
                let pokemonTypes = (result as! Pokemon).mutableSetValue(forKey: "types").allObjects as [AnyObject]
                var dict = [String:String]()
                for t in pokemonTypes {
                    //let slot = (t as! SType).slot!
                    let typeName = (t as! PokemonType).name
                    dict["name"] = typeName
                    let type = SType(slot: 1, type: dict)
                    types.append(type)
                }
                let pokemon = SPokemon(id: object_id, name: name, sprites: sprites, types: types, image_url: image_url)
                results.append(pokemon as SPokemon)
            }
        } catch {
            print(error)
        }
        return results
    }

    // MARK: - Valida los datos del objeto SPokemon.
    func validateData(sPokemon: SPokemon? = nil, isDataOk isComplete: inout Bool) {
        isComplete = true
        let moc = SingleManagedObjectContext.shared.getMOC()
        if sPokemon != nil {
            // Mandatory data for record
            guard let _ = sPokemon?.name else {
                isComplete = false
                return
            }
            
            guard let _: Int16 = sPokemon?.id else {
                isComplete = false
                return
            }

            guard let _ = sPokemon?.sprites?.front_default else {
                isComplete = false
                return
            }
            
            let pokemonFetched = fetchSinglePokemonDataFrom(entity: .pokemon, byName: (sPokemon?.name?.lowercased())!)
            
            if pokemonFetched == nil {
                let forStorage = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: moc)
                forStorage.setValue(sPokemon?.name, forKey: "name")
                forStorage.setValue(sPokemon?.id, forKey: "object_id")
                forStorage.setValue(sPokemon?.sprites?.front_default, forKey: "front_default")
                forStorage.setValue(sPokemon?.image_url, forKey: "image_url")
                
                //var types = [PokemonType]()
                for t in (sPokemon?.types)! {
                    //let slot = t.type!["slot"]
                    let name = t.type!["name"]
                    let type = NSEntityDescription.insertNewObject(forEntityName: "PokemonType", into: moc)
                    type.setValue(name, forKey: "name")
                    //type.setValue(forStorage, forKey: "pokemon")
                    //types.append(type as! PokemonType)
                    (forStorage as! Pokemon).addToTypes(type: type as! PokemonType)
                }
                //forStorage.setValue(types, forKey: "types")
            } else {
                pokemonFetched!.setValue(sPokemon?.name, forKey: "name")
                pokemonFetched!.setValue(sPokemon?.id, forKey: "object_id")
                pokemonFetched!.setValue(sPokemon?.sprites?.front_default, forKey: "front_default")
                pokemonFetched!.setValue(sPokemon?.image_url, forKey: "image_url")
            }
        }
    }

    // MARK: - Valida los datos del objeto SPokemonBase.
    func validateData(sPokemonBase: SPokemonBase? = nil, isDataOk isComplete: inout Bool) {
        isComplete = true
        let moc = SingleManagedObjectContext.shared.getMOC()
        if sPokemonBase != nil {
            // Mandatory data for record
            if (sPokemonBase?.name.isEmpty)! {
                isComplete = false
            }
            if (sPokemonBase?.url.isEmpty)! {
                isComplete = false
            }
            if isComplete {
                let pokemonFetched = fetchSinglePokemonDataFrom(entity: .pokemon_base, byName: (sPokemonBase?.name.lowercased())!)
                if pokemonFetched == nil {
                    let forStorage = NSEntityDescription.insertNewObject(forEntityName: "PokemonBase", into: moc)
                    forStorage.setValue(sPokemonBase?.name, forKey: "name")
                    forStorage.setValue(sPokemonBase?.url, forKey: "url")
                } else {
                    pokemonFetched!.setValue(sPokemonBase?.name, forKey: "name")
                    pokemonFetched!.setValue(sPokemonBase?.url, forKey: "url")
                }
            }
        }
    }

    // MARK: - Precedimiento de guardado de un objeto SPokemon
    func save(sPokemon: SPokemon) -> Bool {
        let moc = SingleManagedObjectContext.shared.getMOC()
        var isSafeData: Bool = true
        do {
            validateData(sPokemon: sPokemon, isDataOk: &isSafeData)
            if isSafeData {
                try moc.save()
            }
        } catch let error as NSError {
            print("No se pudo guardar los datos.  Error: \(error.localizedDescription)")
            print("\(error.domain)")
            print("\(error.code)")
        }
        return isSafeData
    }

    // MARK: - Precedimiento de guardado de un objeto SPokemonBase
    func save(sPokemonBase: SPokemonBase) -> Bool {
        let moc = SingleManagedObjectContext.shared.getMOC()
        var isSafeData: Bool = true
        do {
            validateData(sPokemonBase: sPokemonBase, isDataOk: &isSafeData)
            if isSafeData {
                try moc.save()
            }
        } catch {
            print("No se pudo guardar los datos.  Error: \(error.localizedDescription)")
        }
        return isSafeData
    }


}
