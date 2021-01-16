//
//  SourceService.swift
//  NewsApp
//
//  Created by Андрей Бобр on 27.12.20.
//

import Foundation

class SourceService: SourceProtocol {
    
    private let networkManager = NetworkManager.shared
    
    func fetchSources(    country: String = "",
                          category: Category? = nil,
                          language: String = "",
                          completion: @escaping (Result<Sources, NetworkError>) -> Void) {
        
        let params = ["country" : country,
                      "category": category ?? "",
                      "language": language] as [String : Any]
        print(params)
        self.networkManager.get(path: .sourceUrl,
                                params: params as [String : Any],
                                completion: completion)
    }
}
