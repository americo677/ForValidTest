//
//  UIViewExt.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

extension UIView {
    
    /* MARK: Ajusta el background del view en gradiente de forma vertical */
    func setVerticalGradientBackground(leftColor: UIColor, rightColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        //gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.5]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
