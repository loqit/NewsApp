//
//  BookmarkViewModel.swift
//  NewsApp
//
//  Created by Андрей Бобр on 29.01.21.
//

import Foundation
import CoreData

class BookmarkViewModel {
    
    private var context: NSManagedObjectContext
    private var id: UUID
    
    init(with context: NSManagedObjectContext, by id: UUID) {
        self.context = context
        self.id = id
    }
    
    // Get Bookmark by id
    func fetchBookmark() -> Bookmark? {
        let fetchRequest: NSFetchRequest<Bookmark> = NSFetchRequest(entityName: "Bookmark")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        fetchRequest.fetchLimit = 1
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func saveToBookmark(article: Article) {
        // Checking if a Bookmark exists
        guard fetchBookmark() == nil else {
            return
        }
        
        let bookmark = Bookmark(context: self.context)
        
        bookmark.title              = article.title
        bookmark.url                = article.url
        bookmark.urlToImage         = article.urlToImage
        bookmark.publishedAt        = article.publishedAt
        bookmark.articleDescription = article.articleDescription
        
        bookmark.id                 = article.id
        print("Save \(bookmark.title)")
        saveContext()
    }
    
    func deleteFromBookmark() {
        // Checking if a Bookmark exists
        guard let bookmark = fetchBookmark() else {
            return
        }
        print("Delete \(bookmark.title)")
        context.delete(bookmark)
        saveContext()
    }
    
    private func saveContext () {
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                context.rollback()
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }
}
