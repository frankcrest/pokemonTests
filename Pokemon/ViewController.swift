//
//  ViewController.swift
//  Pokemon
//
//  Created by Sam Meech-Ward on 2018-02-20.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var pokemons: [Pokemon] = []
  var networkManager: NetworkerType = NetworkManager()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let pokemonAPI = PokemonAPIRequest(networker: networkManager)
    pokemonAPI.getAllPokemons { (pokemons, error) in
      if let error = error {
        print("Error: \(error)")
      }
      guard let pokemons = pokemons else {
        print("Error getting pokemon")
        return
      }
      self.pokemons = pokemons
      OperationQueue.main.addOperation {
        self.tableView.reloadData()
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}


extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pokemons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    
    let pokemon = pokemons[indexPath.row]
    cell.textLabel?.text = pokemon.name
    
    return cell
  }
}
