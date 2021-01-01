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
    
    private let bookMarkButton = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(toFavAction))
    private let shareButton = UIBarButtonItem(image: UIImage(named: "upload"), style: .plain, target: self, action: #selector(shareAction))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavController()
        self.configureActivityIndicator()
        self.configureObservation()
        self.configureWebView()

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
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
    }
    
    private func configureObservation() {
        self.observation = self.webView.observe(\.isLoading, options: .new) { [weak self] webView, change in
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
        self.loadRequest()
    }
    
    private func configureWebView() {
        self.webView.frame = self.view.frame
        self.webView.frame.origin.y = 90
        self.view.addSubview(self.webView)
    }
    
    private func loadRequest() {
        guard let url = URL(string: "https://apple.com") else {
            return
        }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}
