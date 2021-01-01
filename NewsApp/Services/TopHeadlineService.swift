//
//  TopHeadlineService.swift
//  NewsApp
//
//  Created by Андрей Бобр on 27.12.20.
//

import Foundation

class TopHeadlineService {
    
    private let networkManager = NetworkManager.shared
    
    func fetchTopHeadline(keyword: String = "",
                          country: String = "",
                          category: Category = .general,
                          pageSize: Int = 20,
                          page: Int = 1,
                          completion: @escaping (Result<News, NetworkError>) -> Void) {
        
        let params = ["q" : keyword,
                      "country" : country,
                      "category" : category,
                      "pageSize": pageSize,
                      "page" : page] as [String : Any]
        print(params)
        self.networkManager.get(path: NetworkConstants.topHeadlinesUrl,
                                params: params as [String : Any],
                                completion: completion)
    }
}
