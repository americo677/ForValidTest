//
//  SPokemon.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 9/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import Foundation

class SPokemon: Codable {
    var id: Int16?
    var name: String?
    var image_url: String?
    var sprites: SSprite?
    var types: [SType]?
    var image_data: Data? = nil
    
    init(id: Int16, name: String, sprites: SSprite?, types: [SType]?, image_url: String? = nil) {
        self.id = id
        self.name = name
        self.sprites = sprites!
        self.types = types!
        self.image_url = image_url
    }
}
