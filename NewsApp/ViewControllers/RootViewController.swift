//
//  RootViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import UIKit

class RootViewController: UIViewController {

    private let serviceHeadline = TopHeadlineService()
    private let serviceEverythong = EverythingService()
    private let searchController = UISearchController(searchResultsController: nil)
    var tableView = UITableView()
    var articles = [Article]()
    
    private let filterButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(toFilter))
    
    struct Cells {
        static let articleCell = "ArticleCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavController()
        configureSearchBar()
        configureTableView()
        fetchHeadlines()
    }
    
    @objc
    private func toFilter(_ sender: UIBarButtonItem) {
        print("pressed")
    }
    
    func configureSearchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        let items = SopeOptions.allCases.map { $0.rawValue }
        searchController.searchBar.scopeButtonTitles = items
        searchController.searchBar.delegate = self
    }
    
    func configureNavController() {
        self.title = "News"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [filterButton]
        filterButton.tintColor = .black
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let viewController = PostViewController()
        if let url = article.url {
            viewController.url = url
        }
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension RootViewController {
    
    func fetchHeadlines(keyword: String = "",
                        country: String = "",
                        category: Category = .general,
                        pageSize: Int = 20,
                        page: Int = 1) {
        DispatchQueue.global().async {
            self.serviceHeadline.fetchTopHeadline(keyword: keyword, country: country, category: category, pageSize: pageSize, page:  page) { result in
                switch result {
                case .success(let news):
                    let data = news.articles ?? []
                    self.updateTableView(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        }

    }
    
    func fetchEverything(keyword: String = "",
                         keywordTitle: String = "",
                         sources: String = "",
                         domains: String = "",
                         excludeDomains: String = "",
                         from: String = "",
                         to: String = "",
                         language: String = "",
                         sortBy: Sorting = .publishedAt,
                         pageSize: Int = 20,
                         page: Int = 1) {
        
        DispatchQueue.global().async {
            self.serviceEverythong.fetchEverything(keyword: keyword, keywordTitle: keywordTitle, sources: sources, from: from, to: to, language: language, sortBy: sortBy, pageSize: pageSize, page: page) { result in
                switch result {
                case .success(let news):
                    let data = news.articles ?? []
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

extension RootViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                fetchHeadlines(keyword: text)
            case 1:
                fetchEverything(keyword: text)
            default:
                fetchHeadlines(keyword: text)
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            fetchHeadlines()
        case 1:
            fetchEverything()
        default:
            fetchHeadlines()
        }
    }

}

enum SopeOptions: String, CaseIterable {
    case topHeadline = "Top Headlines"
    case everything  = "Everything"
}
