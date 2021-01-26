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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
       // fetchBookmarks()
    }
    /*
    func fetchBookmarks() {
        let context = CoreContext()
       // let data = context.fetchBookmarks()
        guard let data = context.fetchBookmarks() else {
            return
        }
        for item in data {
            let article =  Article(source: nil, author: nil, title: item.title, articleDescription: item.articleDescription, url: item.url, urlToImage: item.urlToImage, publishedAt: item.publishedAt, content: nil)
            articlesList.append(article)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }*/

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
        return cell
    }
    
    
}
