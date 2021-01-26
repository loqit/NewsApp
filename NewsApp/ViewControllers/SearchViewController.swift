//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 21.01.21.
//

import UIKit

class SearchViewController: UIViewController {

    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var service: ParseProtocol?
    private var requestOptions = RequestOptions()
    private var articleList = [Article]()
    
    // MARK: - CoreData context
    private let coreDataContainer = AppDelegate.persistentContainer
    private let context = AppDelegate.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        configureTableView()
        configureNavBar()
        configureSearchBar()
    }
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
  
        searchController.searchBar.delegate = self
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
      //  let filterButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(toFilter))
      //  filterButton.tintColor = .black
      //  navigationItem.rightBarButtonItem = filterButton
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        
        tableView.rowHeight = 370
        tableView.register(UINib(nibName: ArticleCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleCell.identifier)
        tableView.pin(to: view)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SearchViewController {
    
    func fetchArticles(type: ScopeOptions,
                       options: RequestOptions,
                       page: Int = 1) {
        self.service = NewsService()
        DispatchQueue.global().async {
            self.service?.fetchArticles(type: type, options: options, page: page) { result in
                switch result {
                case .success(let news):
                   
                    if let data = news.articles {
                        self.updateTableView(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

    }
    
    func updateTableView(with data: [Article]) {
        DispatchQueue.main.async {
            self.articleList = data
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier) as! ArticleCell
        let article = articleList[indexPath.row]
        cell.set(article: article)
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            requestOptions.keyword = text
            fetchArticles(type: .everything, options: requestOptions)
        }
    }
}

