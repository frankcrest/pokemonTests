//
//  NetworkManager.swift
//  Pokemon
//
//  Created by Sam Meech-Ward on 2018-02-21.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import Foundation

class NetworkManager: NetworkerType {
  
  func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    let dataTask = urlSession.dataTask(with: url, completionHandler: completionHandler)
    dataTask.resume()
  }
}
