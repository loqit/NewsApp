//
//  JSONDecoder+Context.swift
//  NewsApp
//
//  Created by Андрей Бобр on 26.01.21.
//

import Foundation
import CoreData

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}
