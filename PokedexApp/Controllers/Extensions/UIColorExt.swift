//
//  UIColorExt.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import QuartzCore

extension UIColor {
    
    static let pokemonSelected = UIColor(red: 153.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    static let grass = UIColor(red: 0.0, green: 204.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    
    // MARK: - Aclara un color dado de acuerdo al porcentaje suministrado.
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    // MARK: - Oscurece un color dado de acuerdo al porcentaje suministrado.
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    // MARK: - Realiza el ajuste de un color de acuerdo al porcentaje suministrado positivo/negativo -> aclarar/oscurecer.
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    static var random = UIColor(red: .random(in: 0.3...1),
                                green: .random(in: 0.2...1),
                                blue: .random(in: 0.3...1),
                       alpha: 1.0)

}
