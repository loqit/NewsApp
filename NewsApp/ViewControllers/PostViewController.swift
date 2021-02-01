//
//  PostViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import UIKit
import WebKit

class PostViewController: UIViewController {

    @objc
    private var webView             = WKWebView()
    private let activityIndicator   = UIActivityIndicatorView()
    private var observation: NSKeyValueObservation?
    var article = Article()
    
    private var isOpen = false
    
    
    // MARK: - CoreData context
    private let context = AppDelegate.backgroundContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
        configureWebView()
        configureActivityIndicator()
        configureObservation()
    }
    
    deinit {
        observation?.invalidate()
    }
    
    private func configureNavController() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let bookMarkButton = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(addToBookmark))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction(_:)))
        let noteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(makeNote))
        
        bookMarkButton.tintColor = .black
        shareButton.tintColor    = .black
        noteButton.tintColor     = .black
       
        navigationItem.rightBarButtonItems = [shareButton, noteButton, bookMarkButton]
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    private func configureObservation() {
        observation = webView.observe(\.isLoading, options: .new) { [weak self] webView, change in
            guard let self = self, let isLoading = change.newValue else {
                return
            }
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Make note
    @objc
    private func makeNote() {
        guard let url = self.article.url else {
            return
        }
        let noteVM = NoteViewModel(with: self.context, by: url)
        let note = noteVM.fetchNotes()

        guard (note?.passwordHash) != nil else {

            let vc = NoteViewController()
            vc.article = self.article
            let navVC = UINavigationController(rootViewController: vc)
            self.present(navVC, animated: true)
            return
        }
        configureAlert()
    }
    
    // MARK: - Add to Bookmark
    @objc
    private func addToBookmark(_ sender: UIBarButtonItem) {
        guard let url = article.url else {
            return
        }
        let bookmarkVM = BookmarkViewModel(with: context, by: url)
        let isBookmark = bookmarkVM.fetchBookmark()
        if isBookmark == nil {
            bookmarkVM.saveToBookmark(article: article)
        } else {
            bookmarkVM.deleteFromBookmark()
        }
    }
    
    @objc
    private func shareAction(_ sender: UIBarButtonItem) {
        var items = [String]()
        guard let url = article.url else { return }
        items.append(url)
        let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let url = article.url else { return }
        loadRequest(from: url)
    }
    
    private func configureWebView() {
        webView.frame = view.frame
        webView.frame.origin.y = 90
        view.addSubview(webView)
        webView.pin(to: view)
    }
    
    private func loadRequest(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func configureAlert() {
        
        let alert = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Password"
            textfield.isSecureTextEntry = true
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitButton = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textfield = alert.textFields![0]
            guard let url = self.article.url, let password = textfield.text else {
                return
            }
            let noteVM = NoteViewModel(with: self.context, by: url)
            let note = noteVM.fetchNotes()
            let passHash = noteVM.calcHash(from: password)

            guard let rightPass = note?.passwordHash else {
                return
            }
            if passHash == rightPass {
                
                let vc = NoteViewController()
                vc.article = self.article
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            }
        }
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        present(alert, animated: true)
    }
}


