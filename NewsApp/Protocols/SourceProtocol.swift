//
//  SourceProtocol.swift
//  NewsApp
//
//  Created by Андрей Бобр on 15.01.21.
//

import Foundation

protocol SourceProtocol {
    func fetchSources(    country: String,
                          category: Category?,
                          language: String,
                          completion: @escaping (Result<Sources, NetworkError>) -> Void)
}
