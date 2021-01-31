//
//  NoteViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 31.01.21.
//

import UIKit

class NoteViewController: UIViewController {

    private var textView = UITextView()
    private var context = AppDelegate.backgroundContext
    var article = Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureNavController()
        
    }
    
    
    @objc
    private func saveNote() {
        guard let url = article.url, let text = textView.text else {
            return
        }
        let note = NoteViewModel(with: context, by: url)
        note.createNote(with: text)
        
        dismiss(animated: true)
    }
    
    func configureTextView() {
        
        guard let url = article.url else {
            return
        }
        let note = NoteViewModel(with: context, by: url)
        
        textView.frame = view.bounds
        textView.backgroundColor = .white
        textView.isEditable = true
        textView.font = UIFont(name: "Helvetica", size: 17)
        textView.text = note.fetchNotes()?.text ?? ""
        view.addSubview(textView)
        
    }

    func configureNavController() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveNote))
        navigationItem.leftBarButtonItem = doneButton
    }
    
}
