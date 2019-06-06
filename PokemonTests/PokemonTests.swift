//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Frank Chen on 2019-06-06.
//  Copyright © 2019 lighthouse-labs. All rights reserved.
//

import XCTest
@testable import Pokemon

class PokemonTests: XCTestCase {
  
  var networkManager:NetworkerType = NetworkManager()
  
  let mockNetworkManagerReal = MockNetworkManager()
  
  var viewController: ViewController!
  
  override func setUp() {
    super.setUp()
     viewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController)
  }
  
  func test_jsonObjectFromData_GivenEmptyData_ShouldThrowAnError() {
    let pokemonRequest = PokemonAPIRequest(networker: networkManager)
    let data = Data()
    XCTAssertThrowsError(try pokemonRequest.jsonObject(fromData: data))
  }
  
  func test_jsonObjectFromData_GivenInvalidJsonData_ShouldThrowAnError() {
    let networker = networkManager
    let pokemonRequest = PokemonAPIRequest(networker: networker)
    
    let invalidJSON = ""
    let data = invalidJSON.data(using: .utf8)!
    XCTAssertThrowsError(try pokemonRequest.jsonObject(fromData: data))
  }
  
  func test_jsonObjectFromData_GivenJSONObjectData_ShouldReturnJSONObject() {
    let networker = networkManager
    let pokemonRequest = PokemonAPIRequest(networker: networker)
    
    let validJSON = "{\"\":\"\"}"
    let data = validJSON.data(using: .utf8)!
    guard let result = try! pokemonRequest.jsonObject(fromData: data) as? [String: String] else {
      XCTFail("Invalid JSON returned")
      return
    }
    XCTAssertEqual(result, ["": ""])
  }
  
  func test_buildURLFromString_GivenValidString_ShouldReturnValidURL(){
    let networker = networkManager
    let request = PokemonAPIRequest(networker: networker)
    
    guard let result = request.buildURL(endpoint: "hello") else {return}
    let expected = URL.init(string: "https://pokeapi.co/api/v2/hello")
    XCTAssertEqual(result, expected)
  }
  
  func test_pokemonFromJson_GivenJson_ShouldReturnPokemonArray(){
    let networker = networkManager
    let pokemonRequest = PokemonAPIRequest(networker: networker)
    
    let json: [String: Any] = [
      "results": [["name":"name1","url":"url1"],["name":"name2","url":"url2"]],
      "phone": "714-781-4565",
      "company_name": "The Walt Disney Company",
      "address_line1": "500 South Buena Vista Street",
      "city_locality": "Burbank",
      "state_province": "CA",
      "postal_code": "91521",
      "country_code": "US"
    ]
    
    let pokemons = try! pokemonRequest.pokemons(fromJSON: json)
    XCTAssertEqual(pokemons.count, 2)
  }
  
  func test_pokemonFromJson_GivenInvalidJson_ShouldReturnERROR(){
    let networker = networkManager
    let pokemonRequest = PokemonAPIRequest(networker: networker)
    
    let json: [String: Any] = [
      "phone": "714-781-4565",
      "company_name": "The Walt Disney Company",
      "address_line1": "500 South Buena Vista Street",
      "city_locality": "Burbank",
      "state_province": "CA",
      "postal_code": "91521",
      "country_code": "US"
    ]
    
    XCTAssertThrowsError(try pokemonRequest.pokemons(fromJSON: json))
  }
  
  func test_jsonObjectFromDataResponseError_GivenValidValue_ShouldReturnJson(){
    let networker = networkManager
    let pokemonRequest = PokemonAPIRequest(networker: networker)
    
    let validJSON = "{\"\":\"\"}"
    let data = validJSON.data(using: .utf8)!
    guard let result = try! pokemonRequest.jsonObject(fromData: data, response: nil, error: nil) as? [String: String] else {
      XCTFail("Invalid JSON returned")
      return
    }
    XCTAssertEqual(result, ["": ""])
  }
  
  func test_jsonObjectFromDataResponseError_GivenError_ShouldReturnError(){
    let networker = networkManager
    let pokemonRequest = PokemonAPIRequest(networker: networker)
    
    let error = PokemonAPIError.badURL
    let validJSON = "{\"\":\"\"}"
    let data = validJSON.data(using: .utf8)!
    XCTAssertThrowsError(try pokemonRequest.jsonObject(fromData: data, response: nil, error: error))
  }
  
  func test_jsonObjectFromDataResponseError_givenInvalidData_ShouldReturnError(){
    let networker = networkManager
    let pokemonRequest = PokemonAPIRequest(networker: networker)
  
    XCTAssertThrowsError(try pokemonRequest.jsonObject(fromData: nil, response: nil, error: nil))
  }
  
  func test_getAllPokemonsGivenURL_callsNetworkManager(){
    let pokemonRequest = PokemonAPIRequest(networker: mockNetworkManagerReal)
    pokemonRequest.getAllPokemons { (pokemon, error) in
      XCTAssert(error == nil)
    }
  }
  
  func test_getAllPokemonsGivenURL_returnValidData(){
    let pokemonRequest = PokemonAPIRequest(networker: mockNetworkManagerReal)
    pokemonRequest.getAllPokemons { (pokemon, error) in
      guard let pokemon = pokemon else{return}
      XCTAssert(pokemon.count == 2)
    }
  }
  
  func test_getAllPokemonsGivenURL_returnInvalidData(){
    let networkManager = mockNetworkManagerReal
    networkManager.jsonDict = ["string":""]
    let pokemonRequest = PokemonAPIRequest(networker: networkManager)
    pokemonRequest.getAllPokemons { (pokemon, err) in
      let pokeErr:PokemonAPIError = err as! PokemonAPIError
      XCTAssertEqual(PokemonAPIError.invalidJSON, pokeErr)
    }
  }
  
  func test_shouldBeDatasource(){
    _ = viewController.view
    XCTAssert(viewController.tableView.dataSource === viewController)
  }
  
  func test_tableviewPopulatedFromNetworkRequest(){
    let viewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController)
    let networkManager = MockNetworkManager()
    viewController.networkManager = networkManager
    _ = viewController.view
    XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), 2)
  }
}
