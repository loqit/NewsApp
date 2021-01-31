//
//  Core.swift
//  NewsApp
//
//  Created by Андрей Бобр on 30.01.21.
//

import Foundation

class Core {
    
    static let shared = Core()
    private let key = "isNewUser"
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: key)
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: key)
    }
}
