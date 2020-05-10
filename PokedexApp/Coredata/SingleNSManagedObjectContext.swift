//
//  SingleNSManagedObjectContext.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import CoreData

class SingleManagedObjectContext {
    
    private var _moc: NSManagedObjectContext
    
    static let shared = SingleManagedObjectContext()

    private init(_ moc: NSManagedObjectContext = DataManager.shared.managedObjectContext) {
        _moc = moc
    }
    
    func getMOC() -> NSManagedObjectContext {
        return _moc
    }
    
    func setMOC(_ moc: NSManagedObjectContext) {
        _moc = moc
    }
}
