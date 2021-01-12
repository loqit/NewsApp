//
//  FilterViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 8.01.21.
//

import UIKit

class FilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filters"
        self.view.backgroundColor = .gray
    }

    private func setOptions() {
        // TopHeadlines
        // country(choose), category(choose)
        
        // Everything
        // from(enter), to(enter), language(choose), sortBy(choose)
        
        // Common
        // pageSize(enter), source(choose)
        
        // return struct with this options (RequestOptions)
    }

}
 
