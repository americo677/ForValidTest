//
//  Pokemon+CoreDataProperties.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 9/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var front_default: String?
    @NSManaged public var object_id: Int16
    @NSManaged public var name: String?
    @NSManaged public var image_url: String?
    @NSManaged public var types: NSSet?

}

// MARK: Generated accessors for types
extension Pokemon {

    @objc(addTypesObject:)
    @NSManaged public func addToTypes(_ value: PokemonType)

    @objc(removeTypesObject:)
    @NSManaged public func removeFromTypes(_ value: PokemonType)

    @objc(addTypes:)
    @NSManaged public func addToTypes(_ values: NSSet)

    @objc(removeTypes:)
    @NSManaged public func removeFromTypes(_ values: NSSet)

}
