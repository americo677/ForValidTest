//
//  PokemonType+CoreDataProperties.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 9/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//
//

import Foundation
import CoreData


extension PokemonType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonType> {
        return NSFetchRequest<PokemonType>(entityName: "PokemonType")
    }

    @NSManaged public var name: String?
    @NSManaged public var pokemon: Pokemon?

}
