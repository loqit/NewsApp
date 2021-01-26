//
//  Language.swift
//  NewsApp
//
//  Created by Андрей Бобр on 26.01.21.
//

import Foundation

enum Language: String, CaseIterable {
    case ar, de, en, es, fr, he, it, nl, no, pt, ru, se, ud, zh
    
    static func getCurrLanguage() -> Language {
        let code = String(Locale.preferredLanguages[0].prefix(2))

        for lang in Language.allCases {
            if code == lang.rawValue {
                return lang
            }
        }
        return .en
    }
}
