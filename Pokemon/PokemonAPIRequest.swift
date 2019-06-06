//
//  PokemonNetworkManager.swift
//  Pokemon
//
//  Created by Sam Meech-Ward on 2018-02-21.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import Foundation

protocol NetworkerType {
  func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
}

enum PokemonAPIError: Error {
  case badURL
  case requestError
  case invalidJSON
}

class PokemonAPIRequest {

  var networker: NetworkerType
  
  init(networker: NetworkerType) {
    self.networker = networker
  }
}

/// Methods that should be called by other classes
extension PokemonAPIRequest {
  
  func getAllPokemons(completionHandler: @escaping ([Pokemon]?, Error?) -> Void) {
    guard let url = buildURL(endpoint: "pokemon") else {
      completionHandler(nil, PokemonAPIError.badURL)
      return
    }
    
    self.networker.requestData(with: url) { (data, urlRequest, error) in
      
      var json: [String: Any] = [:]
      var result: [Pokemon] = []
      do {
        json = try self.jsonObject(fromData: data, response: urlRequest, error: error)
        result = try self.pokemons(fromJSON: json)
      } catch let error {
        completionHandler(nil, error)
        return
      }
      
      completionHandler(result, nil)
    }
  }
  
}

/// URL
extension PokemonAPIRequest {
  func buildURL(endpoint: String) -> URL? {
    var componenets = URLComponents()
    componenets.scheme = "https"
    componenets.host = "pokeapi.co"
    var componentsURL = componenets.url
    componentsURL = componentsURL?.appendingPathComponent("api")
    componentsURL = componentsURL?.appendingPathComponent("v2")
    componentsURL = componentsURL?.appendingPathComponent(endpoint)
    
    return componentsURL
  }
}

/// JSON Parsing
extension PokemonAPIRequest {
  
  func jsonObject(fromData data: Data) throws -> [String: Any] {
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    
    guard let results = jsonObject as? [String: Any] else {
      throw PokemonAPIError.invalidJSON
    }
    
    return results
  }
  
  func pokemons(fromJSON json: [String: Any]) throws -> [Pokemon] {
    guard let results = json["results"] as? [[String: String]] else {
      throw PokemonAPIError.invalidJSON
    }
    
    var pokemons: [Pokemon] = []
    for result in results {
      guard let name = result["name"], let url = result["url"] else {
        throw PokemonAPIError.invalidJSON
      }
      let pokemon = Pokemon(name: name, url: url)
      pokemons.append(pokemon)
    }
    
    return pokemons
  }
  
  func jsonObject(fromData data: Data?, response: URLResponse?, error: Error?) throws -> [String: Any] {
    if let error = error {
      throw error
    }
    guard let data = data else {
      throw PokemonAPIError.requestError
    }
    
    return try jsonObject(fromData: data)
  }
  
}
