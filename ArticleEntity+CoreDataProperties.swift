//
//  ArticleEntity+CoreDataProperties.swift
//  NewsApp
//
//  Created by Андрей Бобр on 26.01.21.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var title: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var id: UUID?

}

extension ArticleEntity : Identifiable {

}
