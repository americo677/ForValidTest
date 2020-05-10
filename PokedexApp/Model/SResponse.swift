//
//  SResponse.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 9/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import Foundation

struct SResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [SResult]?
}
