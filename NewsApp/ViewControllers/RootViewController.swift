//
//  RootViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import UIKit

class RootViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var tableView = UITableView()
    
   // private var collectionView: UICollectionView?
   // private let mainScrollView = UIScrollView()
    
    private var articles = [Article]()
    private var requestOptions = RequestOptions()
    private var service: ParseProtocol?
    
    // MARK: - CoreData context
    private let context = AppDelegate.backgroundContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavController()
        configureSearchBar()
        configureTableView()
        configureRefresh()
        fetchArticles(type: .topHeadline, options: requestOptions)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: - OnBoarding
        if Core.shared.isNewUser()
        {
            let vc = OnBoardingViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func configureRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    
    @objc
    func refresh(_ refreshControl: UIRefreshControl) {
        fetchArticles(type: .topHeadline, options: requestOptions)
        refreshControl.endRefreshing()
    }

    
    // MARK:- Navigate to FilterViewController
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
        //let items = ScopeOptions.allCases.map { $0.rawValue }
        //searchController.searchBar.scopeButtonTitles = items
        
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
// TODO: - Make scroll up to update
extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier) as! ArticleCell
        let article = articles[indexPath.row]
        cell.set(article: article)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let viewController = PostViewController()
        
        viewController.article = article
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Adding to Bookmark
extension RootViewController: ArticleCellDelegate {
    func bookmarkTapped(on article: Article) {
        //print(article.hashValue)
        //let hash = Int64(article.hashValue)
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
    
}

// MARK: - Fetch Articles
extension RootViewController {
    
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
            self.articles = data
            self.tableView.reloadData()
        }
    }
}

extension RootViewController: OptionsDelegate {
    
    // MARK: - Get options from FilterViewController
    
    func setOptions(with requestOptions: RequestOptions) {
        self.requestOptions = requestOptions
        fetchArticles(type: .topHeadline, options: requestOptions)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RootViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        requestOptions.keyword = searchBar.text ?? ""
        fetchArticles(type: .topHeadline, options: requestOptions)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.isActive = false
        searchBar.text = requestOptions.keyword
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        requestOptions = RequestOptions()
        articles = []
        self.fetchArticles(type: .topHeadline, options: self.requestOptions)

    }
}



