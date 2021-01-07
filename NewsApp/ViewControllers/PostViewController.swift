//
//  PostViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import UIKit
import WebKit

class PostViewController: UIViewController {

    @objc private var webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    private var observation: NSKeyValueObservation?
    var url = ""
    
    private let bookMarkButton = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(toFavAction))
    private let shareButton = UIBarButtonItem(image: UIImage(named: "upload"), style: .plain, target: self, action: #selector(shareAction))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
        configureWebView()
        configureActivityIndicator()
        configureObservation()
    }
    
    deinit {
        self.observation?.invalidate()
    }
    
    private func configureNavController() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .black
        self.bookMarkButton.tintColor = .black
        self.shareButton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [shareButton, bookMarkButton]
    }
    
    private func configureActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    private func configureObservation() {
        observation = self.webView.observe(\.isLoading, options: .new) { [weak self] webView, change in
            guard let self = self, let isLoading = change.newValue else {
                return
            }
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }

    @objc
    private func toFavAction() {

    }
    
    @objc
    private func shareAction() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadRequest(from: url)
    }
    
    private func configureWebView() {
        webView.frame = self.view.frame
        webView.frame.origin.y = 90
        self.view.addSubview(webView)
    }
    
    private func loadRequest(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


