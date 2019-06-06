//
//  DetailViewController.swift
//  Pokemon
//
//  Created by Frank Chen on 2019-06-06.
//  Copyright © 2019 lighthouse-labs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var pokemonAbility: [PokemonDetail] = []
  var networkManager: NetworkerType = NetworkManager()
  var pokemonName:String?
  
  @IBOutlet weak var detailTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let pokemonAPI = PokemonAPIRequest(networker: networkManager)
    guard let name = pokemonName else{return}
    pokemonAPI.getDetail(name: name) { (pokemonDetail, err) in
      if let err = err{
        print(err)
      }
      guard let pokeAbility = pokemonDetail  else{return}
      self.pokemonAbility = pokeAbility
      self.detailTableView.reloadData()
    }
  }
}

extension DetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pokemonAbility.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    
    let ability = pokemonAbility[indexPath.row]
    cell.textLabel?.text = ability.name
    
    return cell
  }
}


