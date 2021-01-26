//
//  Country.swift
//  NewsApp
//
//  Created by Андрей Бобр on 26.01.21.
//

import Foundation

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
