//
//  RootViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import UIKit

class RootViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    var tableView = UITableView()
    var articles = [Article]()
    private var requestOptions = RequestOptions()
    
    private var service: ParseProtocol?
    
    struct Cells {
        static let articleCell = "ArticleCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavController()
        configureSearchBar()
        configureTableView()
        fetchArticles(type: .topHeadline, options: requestOptions)
    }
    

    @objc
    private func toFilter() {
        let vc = FilterViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true) 
    }
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        let items = ScopeOptions.allCases.map { $0.rawValue }
        searchController.searchBar.scopeButtonTitles = items
        searchController.searchBar.delegate = self
    }
    
    func configureNavController() {
        self.title = "News"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        let filterButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(toFilter))
        filterButton.tintColor = .black
        navigationItem.rightBarButtonItem = filterButton
        
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
    
    func fetchArticles(type: ScopeOptions,
                       options: RequestOptions,
                       page: Int = 1) {
        self.service = NewsService()
        DispatchQueue.global().async {
            self.service?.fetchArticles(type: type, options: options, page: page) { result in
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

extension RootViewController: OptionsDelegate {
    
    func setOptions(with requestOptions: RequestOptions) {
        print(requestOptions)
        self.requestOptions = requestOptions
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            fetchArticles(type: .topHeadline, options: requestOptions)
        case 1:
            fetchArticles(type: .everything, options: requestOptions)
        default:
            fetchArticles(type: .everything, options: requestOptions)
        }
        self.tableView.reloadData()
    }
}

extension RootViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            requestOptions.keyword = text
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                fetchArticles(type: .topHeadline, options: requestOptions)
            case 1:
                fetchArticles(type: .everything, options: requestOptions)
            default:
                fetchArticles(type: .topHeadline, options: requestOptions)
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        switch selectedScope {
        case 0:
            requestOptions = RequestOptions()
            fetchArticles(type: .topHeadline, options: requestOptions)
        case 1:
            requestOptions = RequestOptions()
            updateTableView(with: [])
        default:
            requestOptions = RequestOptions()
            fetchArticles(type: .topHeadline, options: requestOptions)
        }
    }

}

enum ScopeOptions: String, CaseIterable {
    case topHeadline = "Top Headlines"
    case everything  = "Everything"
}
