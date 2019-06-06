//
//  MockNetworkManager.swift
//  Pokemon
//
//  Created by Frank Chen on 2019-06-06.
//  Copyright © 2019 lighthouse-labs. All rights reserved.
//

import Foundation

class MockNetworkManager:NetworkerType{
  
  var jsonDict: [String: Any] = [
    "results": [["name":"name1","url":"url1"],["name":"name2","url":"url2"]],
    "phone": "714-781-4565",
    "company_name": "The Walt Disney Company",
    "address_line1": "500 South Buena Vista Street",
    "city_locality": "Burbank",
    "state_province": "CA",
    "postal_code": "91521",
    "country_code": "US"
  ]
  
  func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
    
    var jsonData:Data? = nil
    do{
       jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
    }catch {
      completionHandler(nil,nil,PokemonAPIError.invalidJSON)
    }
    
    let urlString = url.absoluteString
    if urlString.hasSuffix("pokemon"){
      completionHandler(jsonData,nil,nil)
    }else{
      completionHandler(nil,nil,PokemonAPIError.badURL)
    }
  }
}
