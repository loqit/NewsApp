//
//  ParseProtocol.swift
//  NewsApp
//
//  Created by Андрей Бобр on 13.01.21.
//

import Foundation

protocol ParseProtocol {
    func fetchArticles(type: ScopeOptions, options: RequestOptions, page: Int, completion: @escaping (Result<News, NetworkError>) -> Void)
}
