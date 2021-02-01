//
//  NoteViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 31.01.21.
//

import UIKit

class NoteViewController: UIViewController {

    private var textView = UITextView()
    private let context = AppDelegate.backgroundContext
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
        let protectButton = UIBarButtonItem(title: "Protect", style: .plain, target: self, action: #selector(protectNote))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = protectButton
    }
    
    @objc
    func protectNote() {
        let alert = UIAlertController(title: "Protect Note", message: "Create password", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Password"
            textfield.isSecureTextEntry = true
        }
        
        let submitButton = UIAlertAction(title: "Confirm", style: .default) { (action) in
            let textfield = alert.textFields![0]
            guard let url = self.article.url else {
                return
            }
            let note = NoteViewModel(with: self.context, by: url)
            
            guard let password = textfield.text else { return }
            note.setPassword(password)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        
        
        self.present(alert, animated: true)
        
    }
}
