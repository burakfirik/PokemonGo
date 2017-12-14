//
//  PokeDexViewController.swift
//  PokemonGo
//
//  Created by Burak Firik on 12/13/17.
//  Copyright © 2017 Burak Firik. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  

  @IBOutlet weak var tableView: UITableView!
  var caughtPokemons:[Pokemon] = []
  var uncaughtPokemons:[Pokemon] = []
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    caughtPokemons = getCaughtPokemon()
    uncaughtPokemons = getUnCaughtPokemon()
    tableView.dataSource = self
    tableView.delegate = self
   
   
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "CAUGHT"
    } else {
      return "UNCAUGHT"
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0) {
      return caughtPokemons.count
    } else {
      return uncaughtPokemons.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    var pokemon: Pokemon
    if indexPath.section == 0 {
      pokemon = caughtPokemons[indexPath.row]
    } else {
      pokemon = uncaughtPokemons[indexPath.row]
    }
    cell.textLabel?.text = pokemon.name
    if let imageName = pokemon.imageName as? String {
      if let image = UIImage(named: imageName) as? UIImage {
       cell.imageView?.image = image
      }
    }
    return cell
  }
  
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
    

  @IBAction func returnedTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}
