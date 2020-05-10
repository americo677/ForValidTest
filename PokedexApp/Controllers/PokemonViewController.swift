//
//  PokemonViewController.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonTagImageView: UIImageView!
    @IBOutlet weak var pokemonInfoTableView: UITableView!
    
    var pokemon: SPokemon?

    var colorMap = ["grass": UIColor.green,
                    "rock": UIColor.brown.lighter(by: 90.0),
                    "poison": UIColor.purple,
                    "ice": UIColor.cyan.lighter(by: 20.0),
                    "bug": UIColor.green.lighter(by: 30.0),
                    "dark": UIColor.gray.darker(by: 10.0),
                    "dragon": UIColor.blue,
                    "electric": UIColor.yellow,
                    "fairy": UIColor.purple.lighter(by: 70.0),
                    "fight": UIColor.orange.darker(by: 20.0),
                    "fire": UIColor.orange.lighter(by: 20.0),
                    "flying": UIColor.blue.lighter(by: 40.0),
                    "ghost": UIColor.purple.lighter(by: 30.0),
                    "ground": UIColor.brown.lighter(by: 40.0),
                    "normal": UIColor.lightGray,
                    "psychic": UIColor.orange,
                    "steel": UIColor.cyan.darker(by: 80.0),
                    "water": UIColor.blue.lighter(by: 60.0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard self.pokemon != nil else {
            return
        }
        
        let imageFileName = self.pokemon?.image_url!
        
        let pokemonImage = getImageFrom(directory: "images", fileName: imageFileName!)
        
        self.pokemonImageView.image = pokemonImage

        self.pokemonNameLabel.text = self.pokemon?.name!.capitalized
        
        let types = pokemon?.types
        var ltypes = [String]()
        for t in types! {
            ltypes.append(t.type!["name"]!)
        }
        
        let type_name = ltypes[0]
        let color = colorMap[type_name] as? UIColor
        let tag_name = "tag_" + type_name
        
        
        self.pokemonTagImageView.image = UIImage(named: tag_name)
        
        self.view.setVerticalGradientBackground(leftColor: (color?.lighter(by: 50.0)!)!, rightColor: (color?.lighter(by: 70.0)!)!)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
