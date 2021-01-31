//
//  NoteDelegate.swift
//  NewsApp
//
//  Created by Андрей Бобр on 31.01.21.
//

import Foundation

protocol NoteDelegate: class {
    func setNote(to article: Article)
}
