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
        fetchArticles()
        print(articles.count)
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
        tableView.rowHeight = 370
        tableView.register(UINib(nibName: Cells.articleCell, bundle: nil), forCellReuseIdentifier: Cells.articleCell)
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
    
    func fetchArticles() {
        var data = [Article]()
        DispatchQueue.global().async {
            self.service.fetchTopHeadline(keyword: "trump") { result in
                switch result {
                case .success(let news):
                    data = news.articles ?? []
                    self.updateTableView(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        }

    }
    
    func updateTableView(with data: [Article]) {
        DispatchQueue.main.async {
            self.articles = data
            self.tableView.reloadData()
        }
    }
}
