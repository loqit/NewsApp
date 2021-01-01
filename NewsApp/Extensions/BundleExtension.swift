//
//  BundleExtension.swift
//  NewsApp
//
//  Created by Андрей Бобр on 27.12.20.
//

import Foundation

extension Bundle {
    
     static func plistRootDictionary(filename: String) -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "plist") else {
            return nil
        }
        let dict = NSDictionary.init(contentsOfFile: path)
        return dict
    }
}
