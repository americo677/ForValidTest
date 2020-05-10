//
//  ACSearchBar.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 10/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class ACSearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        
        layer.cornerRadius = self.frame.size.height / 2
        
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        
        layer.borderColor = UIColor.darkGray.cgColor
    }
}
