//
//  RootViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import UIKit

class RootViewController: UIViewController {

    private let service = TopHeadlineService()
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "News"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "next",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.nextAction))
    }

    @objc
    private func nextAction() {
        let viewController = PostViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }


}
