//
//  EverythingService.swift
//  NewsApp
//
//  Created by Андрей Бобр on 27.12.20.
//

import Foundation

class EverythingService {
    
    private let networkManager = NetworkManager.shared
    
    func fetchEverything( keyword: String = "",
                          keywordTitle: String = "",
                          sources: String = "",
                          domains: String = "",
                          excludeDomains: String = "",
                          from: String = "",
                          to: String = "",
                          language: String = "",
                          sortBy: Sorting = .publishedAt,
                          pageSize: Int = 20,
                          page: Int = 1,
                          completion: @escaping (Result<News, NetworkError>) -> Void) {
        
        let params = ["q" : keyword,
                      "qInTitle" : keywordTitle,
                      "sources" : sources,
                      "domains": domains,
                      "excludeDomains": excludeDomains,
                      "from": from,
                      "to": to,
                      "language": language,
                      "sortBy": sortBy,
                      "pageSize": pageSize,
                      "page" : page] as [String : Any]
        self.networkManager.get(path: .everythingUrl,
                                params: params as [String : Any],
                                completion: completion)
    }
}

enum Sorting {
    case relevancy
    case popularity
    case publishedAt
}
