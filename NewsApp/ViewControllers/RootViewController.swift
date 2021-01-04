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
    var tableView = UITableView()
    var articles = [Article]()
    
    struct Cells {
        static let articleCell = "ArticleCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
        configureTableView()
        
        articles = fetchArticles()
    }
    
    func configureNavController() {
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
        navigationController?.pushViewController(viewController, animated: true)
    }

    
    func configureTableView() {
        self.view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(ArticleCell.self, forCellReuseIdentifier: Cells.articleCell)
        tableView.pin(to: view)
        tableView.backgroundColor = .clear
        
        
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.articleCell) as! ArticleCell
        let article = articles[indexPath.row]
        cell.set(article: article)
        return cell
    }
    
    
}

extension RootViewController {
    func fetchArticles() -> [Article] {
        var articles = [Article]()
        service.fetchTopHeadline(keyword: "trump") { result in
            switch result {
            case .success(let news):
                articles = news.articles ?? []
            case .failure(let error):
                print(error)
            }
        }
        return articles
    }
}
