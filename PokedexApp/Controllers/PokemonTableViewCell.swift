//
//  PokemonTableViewCell.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 7/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    @IBOutlet weak var pokemonIdLabel: UILabel!
    
    @IBOutlet weak var typeImageView3: UIImageView!
    
    @IBOutlet weak var typeImageView2: UIImageView!
    
    @IBOutlet weak var typeImageView1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
