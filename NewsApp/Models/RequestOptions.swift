//
//  RequestOptions.swift
//  NewsApp
//
//  Created by Андрей Бобр on 13.01.21.
//

import Foundation

struct RequestOptions {
    
    var keyword: String = ""
    var country: Country = Country.getCurLocation()
    var category: Category? = nil
    var from: String = ""
    var to: String = ""
    var language: Language = Language.getCurrLanguage()
    var sortBy: Sorting = .publishedAt
    var source: String = ""
    var pageSize: Int = 20
    
}

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

enum Country: String, CaseIterable {
    
    case ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il, `in`, it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za
    case none = ""
    static func getCurLocation() -> Country {
        var code = Locale.current.regionCode
        code = code?.lowercased()
        for country in Country.allCases {
            if code == country.rawValue {
                return country
            }
        }
        return .none
    }
}
