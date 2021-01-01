//
//  NetworkError.swift
//  NewsApp
//
//  Created by Андрей Бобр on 26.12.20.
//

import Foundation

enum NetworkError : String, Error {
    
    case unableToComplite = "Unable to complite your request. Please, try again."
    case invalidResponse  = "Invalid response from server. Please, try again."
    case inavlidData      = "Invalid data from server. Please, try again."
    
}
