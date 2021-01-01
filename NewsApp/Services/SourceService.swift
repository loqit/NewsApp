//
//  SourceService.swift
//  NewsApp
//
//  Created by Андрей Бобр on 27.12.20.
//

import Foundation

class SourceService {
    
    private let networkManager = NetworkManager.shared
    
    func fetchTopHeadline(country: String = "",
                          category: Category = .general,
                          language: String = "",
                          completion: @escaping (Result<Sources, NetworkError>) -> Void) {
        
        let params = ["country" : country,
                      "category" : category,
                      "language": language] as [String : Any]
        print(params)
        self.networkManager.get(path: NetworkConstants.sourceUrl,
                                params: params as [String : Any],
                                completion: completion)
    }
}
