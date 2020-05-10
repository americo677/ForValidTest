//
//  Pokemon+CoreDataExtension.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 9/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

extension Pokemon {
    
    func addToTypes(type: PokemonType) {
        let pokemonTypes = self.mutableSetValue(forKey: "types")
        pokemonTypes.add(type)
    }

}
