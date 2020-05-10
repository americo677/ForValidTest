//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 7/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import Foundation

struct SPokemonBase: Codable {
    var name: String
    var url: String

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}





