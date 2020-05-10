//
//  PokemonsViewController.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 7/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class PokemonsViewController: UIViewController {

    @IBOutlet weak var pokemonsTableView: UITableView!
        
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var searchBar: ACSearchBar!
    
    let scSearchController = UISearchController(searchResultsController: nil)
    
    var isFiltering = false
    
    var pokemonManager = PokemonManager()
    //var sPokemonsBase = [SPokemonBase]()
    var sPokemons: [SPokemon]?
    var sPokemonsFiltred: [SPokemon]?
    var pokemonDic = [String:[String]]()
    var pokemonSelected: SPokemon?

    override func viewDidLoad() {
        super.viewDidLoad()

        pokemonManager.delegate = self
        configSearchBar()
        initTableView(tv: pokemonsTableView)
        let sqllite = getPath("PokedexModel.sqlite")
        print("db: \(sqllite)")
        // carga los datos en el array principal de PokemonBase
        self.pokemonManager.fetchAllPokemonBase()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.pokemonManager.fetchAllPokemonBase()
        //didUpdatePokemon(self.pokemonManager, sPokemons: self.sPokemons!)
        pokemonsTableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "seguePokemonView" {
            let pvc = segue.destination as! PokemonViewController
            pvc.pokemon =  self.pokemonSelected!
        }
    }

}
