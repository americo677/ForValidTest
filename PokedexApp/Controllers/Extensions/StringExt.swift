//
//  StringExt.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import Foundation

extension String {
    
    static let numberFormatter = NumberFormatter()
    
    // MARK: - Retorna el nombre de archivo sin la extensión.
    func getFilenameWithoutExtension() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    // MARK: - Retorna sólo la extensión de un archivo.
    func getFileExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    func occurrencies(_ chr: Character) -> Int {
        var count: Int = 0
        let chars = Array(self)
        
        for char in chars {
            if (chr == char) {
                count += 1
            }
        }
        return count
    }
    
    func doubleValue() -> Double {
        
        let value: NSNumber = NSNumber.init(value: 0)
        String.numberFormatter.maximumFractionDigits = 0
        String.numberFormatter.numberStyle = .none
        
        //nuevo
        String.numberFormatter.numberStyle = .decimal
        
        
        // nuevo
        String.numberFormatter.decimalSeparator = "."
        
        if let result: NSNumber = String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result: NSNumber = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        
        String.numberFormatter.decimalSeparator = "."
        String.numberFormatter.maximumFractionDigits = 2
        
        // nuevo
        String.numberFormatter.numberStyle = .decimal
        
        if let result: NSNumber = String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result: NSNumber = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        
        String.numberFormatter.decimalSeparator = "."
        String.numberFormatter.numberStyle = .currency
        String.numberFormatter.maximumFractionDigits = 2
        
        if let result: NSNumber = String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result: NSNumber = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        
        return value.doubleValue
    }
    
    func floatValue() -> Float {
        let value: NSNumber = NSNumber.init(value: 0)

        String.numberFormatter.decimalSeparator = "."
        String.numberFormatter.maximumFractionDigits = 0
        String.numberFormatter.numberStyle = .none
        
        if let result: NSNumber = String.numberFormatter.number(from: self) {
            return result.floatValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result: NSNumber = String.numberFormatter.number(from: self) {
                return result.floatValue
            }
        }

        String.numberFormatter.decimalSeparator = "."
        String.numberFormatter.maximumFractionDigits = 2
        
        if let result: NSNumber = String.numberFormatter.number(from: self) {
            return result.floatValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result: NSNumber = String.numberFormatter.number(from: self) {
                return result.floatValue
            }
        }

        String.numberFormatter.decimalSeparator = "."
        String.numberFormatter.maximumFractionDigits = 2
        String.numberFormatter.numberStyle = .currency
        
        if let result: NSNumber = String.numberFormatter.number(from: self) {
            return result.floatValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result: NSNumber = String.numberFormatter.number(from: self) {
                return result.floatValue
            }
        }

        return value.floatValue
    }
    
    func doubleFormatter(decimales: Int, estilo: NumberFormatter.Style = .none) -> String {
        let fmt = NumberFormatter()
        
        fmt.numberStyle = estilo
        fmt.maximumFractionDigits = decimales
        
        return fmt.string(from: NSNumber.init(value: self.doubleValue()))!
    }
    
}
