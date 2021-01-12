//
//  RequestOptions.swift
//  NewsApp
//
//  Created by Андрей Бобр on 13.01.21.
//

import Foundation

struct RequestOptions {
    
    var country: Country
    var category: Category
    var from: String
    var to: String
    var language: Language
    var sortBy: Sorting
    var source: String
    var pageSize: Int
}

enum Language: String {
    case ar = "ar"
    case de = "de"
    case en = "en"
    case es = "es"
    case fr = "fr"
    case he = "he"
    case it = "it"
    case nl = "nl"
    case no = "no"
    case pt = "pt"
    case ru = "ru"
    case se = "se"
    case ud = "ud"
    case zh = "zh"
}

enum Country: String {
    case ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il, `in`, it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za
}
