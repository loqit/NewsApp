//
//  ArticleCellDelegate.swift
//  NewsApp
//
//  Created by Андрей Бобр on 27.01.21.
//

import Foundation

protocol ArticleCellDelegate: AnyObject {
    func bookmarkTapped(on article: Article) 
}
