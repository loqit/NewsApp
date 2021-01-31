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

    @objc
    private func makeNote() {
        let vc = NoteViewController()
        vc.article = self.article
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
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
}

extension PostViewController: NoteDelegate {
    func setNote(to article: Article) {
        //
    }
    
    
}
