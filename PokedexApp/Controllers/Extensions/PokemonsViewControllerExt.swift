//
//  PokemonsViewControllerExt.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 7/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

extension PokemonsViewController: PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, sPokemons: [SPokemon]) {
        print("Se ejecuta el delegado didUpdatePokemon:")
        // se ordena el arreglo de pokemon en orden ascendete por el identificador
        self.sPokemons = sPokemons.sorted { $0.id! < $1.id! }
        for p in self.sPokemons! {
            let types = p.types!
            var ltypes = [String]()
            for t in types {
                ltypes.append(t.type!["name"]!)
            }
            self.pokemonDic[p.name!] = ltypes
        }
        self.pokemonsTableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - Extension para UISearchBar
extension PokemonsViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Configuración de la UISearchBar
    func configSearchBar() {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.
        scSearchController.searchResultsUpdater = self
        scSearchController.obscuresBackgroundDuringPresentation = false
        scSearchController.definesPresentationContext = true
        //self.searchBar.scopeButtonTitles = []
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search pokemon..."
        self.searchBar.showsCancelButton = false
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.barStyle = .default
    }
    
    // MARK: - Procedimientos para la UISearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "") {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true
        if !searchText.isEmpty {
            if let nonfiltered = self.sPokemons {
                self.sPokemonsFiltred = nonfiltered.filter {
                    pokemon in return {
                        pokemon.name!.lowercased().contains(searchText.lowercased())
                    }()
                }
            }
        } else {
            isFiltering = false
        }
        self.pokemonsTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: (
            self.searchBar.text?.lowercased())!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: scSearchController)
    }
}


// MARK: - Extensión para UITableView para el manejo de PokemonTableView
extension PokemonsViewController:  UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - Inicializador de la tableView de la vista
    func initTableView(tv: UITableView) {
        tv.delegate = self
        tv.dataSource = self
        
        //tv.frame = self.view.bounds
        tv.autoresizingMask = [.flexibleWidth]
        
        //tableView.backgroundColor = color
        
        let identifier = "pokemonCell"
        let myBundle = Bundle(for: PokemonsViewController.self)
        let nib = UINib(nibName: "PokemonTableViewCell", bundle: myBundle)
        
        tv.register(nib, forCellReuseIdentifier: identifier)
        
        tv.allowsMultipleSelectionDuringEditing = false
        tv.allowsSelectionDuringEditing = true
        
        //initTableViewRowHeight(tableView: tv)
    }

    // MARK: - TableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            if let filtered = self.sPokemonsFiltred {
                if filtered.count > 0 {
                    return filtered.count
                }
            }
        } else {
            if let nonfiltered = self.sPokemons {
                if nonfiltered.count > 0 {
                    return self.sPokemons!.count
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "pokemonCell"
        let cell: PokemonTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? PokemonTableViewCell)!
        
        var pokemon: SPokemon?

        if isFiltering {
            pokemon = self.sPokemonsFiltred![indexPath.row]
        } else {
            pokemon = self.sPokemons![indexPath.row]
        }

        cell.pokemonNameLabel.text = pokemon?.name?.capitalized
        cell.pokemonIdLabel.text = String(format: "#%03d",  pokemon?.id! as! CVarArg)
        
        let imageFileName = (pokemon?.image_url!)!
        
        let pokemonImage = getImageFrom(directory: "images", fileName: imageFileName)
        
        cell.pokemonImageView.image = pokemonImage
        
        let ltypes = self.pokemonDic[(pokemon?.name!)!]

        switch ltypes!.count {
            case 1:
                cell.typeImageView1.image = UIImage.init(named: ltypes![0])
                break
            case 2:
                cell.typeImageView1.image = UIImage.init(named: ltypes![0])
                cell.typeImageView2.image = UIImage.init(named: ltypes![1])
                break
            case 3:
                cell.typeImageView1.image = UIImage.init(named: ltypes![0])
                cell.typeImageView2.image = UIImage.init(named: ltypes![1])
                cell.typeImageView3.image = UIImage.init(named: ltypes![2])
                break
            default:
                break
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.pokemonSelected.lighter(by: 10)
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            self.pokemonSelected = self.sPokemonsFiltred![indexPath.row]
        } else {
            self.pokemonSelected = self.sPokemons![indexPath.row]
        }
        
        self.performSegue(withIdentifier: "seguePokemonView", sender: self)
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }

}
