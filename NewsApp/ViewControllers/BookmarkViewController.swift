//
//  BookmarkViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 20.01.21.
//

import UIKit

class BookmarkViewController: UIViewController {

    private let tableView = UITableView()
    
    private var articlesList = [Article]()
    private var bookmarkList = [Bookmark]()
    // MARK: - CoreData context
    private let context = AppDelegate.backgroundContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchBookmarks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchBookmarks()
    }
    
    func fetchBookmarks() {
       
        do {
            bookmarkList = try context.fetch(Bookmark.fetchRequest())
            
            updateTableView(with: bookmarkList)
        } catch {
            bookmarkList = []
        }

    }
    
    func updateTableView(with data: [Bookmark]) {
        articlesList = []
        for item in data {
            let article = Article(from: item)
            articlesList.append(article)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier) as! ArticleCell
        let article = articlesList[indexPath.row]
        cell.set(article: article)
        cell.delegate = self
        return cell
    }
    
    
}

// MARK: - Adding to Bookmark
extension BookmarkViewController: ArticleCellDelegate {
    func bookmarkTapped(on article: Article) {
        guard let url = article.url else {
            return
        }
        let bookmarkVM = BookmarkViewModel(with: context, by: url)
        bookmarkVM.deleteFromBookmark()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
