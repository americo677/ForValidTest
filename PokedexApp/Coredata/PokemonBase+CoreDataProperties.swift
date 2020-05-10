//
//  PokemonBase+CoreDataProperties.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 9/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//
//

import Foundation
import CoreData


extension PokemonBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonBase> {
        return NSFetchRequest<PokemonBase>(entityName: "PokemonBase")
    }

    @NSManaged public var url: String?
    @NSManaged public var name: String?

}
