//
//  NoteViewModel.swift
//  NewsApp
//
//  Created by Андрей Бобр on 31.01.21.
//

import Foundation
import CoreData
import CryptoKit

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
    
    func fetchPassword() -> Note? {
        let fetchRequest: NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
        
        fetchRequest.predicate = NSPredicate(format: "urlOfArticle == %@", url)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func createNote(with text: String) {
        let note = fetchNotes() ?? Note(context: context)
        note.urlOfArticle = url
        note.text = text
        saveContext()
    }
    
    func setPassword(_ password: String) {
        let note = fetchNotes() ?? Note(context: context)
        note.urlOfArticle = url
        note.passwordHash = calcHash(from: password)
        
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
    
    
    // Password
    
    func calcHash(from inputString: String) -> String {
        let inputData = Data(inputString.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
