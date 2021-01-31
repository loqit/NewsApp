//
//  NoteViewModel.swift
//  NewsApp
//
//  Created by Андрей Бобр on 31.01.21.
//

import Foundation
import CoreData

class NoteViewModel {
    
    private var context: NSManagedObjectContext
    private var url: String
    
    init(with context: NSManagedObjectContext, by url: String) {
        self.context = context
        self.url = url
    }
    
    func fetchNotes() -> Note? {
        let fetchRequest: NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
        
        fetchRequest.predicate = NSPredicate(format: "urlOfArticle == %@", url)
        do {
            return try context.fetch(fetchRequest).last
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func createNote(with text: String) {
        print("createNote \(text)")
        let note = Note(context: context)
        note.urlOfArticle = url
        note.text = text
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
