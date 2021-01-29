//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Андрей Бобр on 7.01.21.
//

import UIKit

class ArticleCell: UITableViewCell {

    static let identifier = "ArticleCell"
    weak var delegate: ArticleCellDelegate?
    lazy private var article = Article()

    
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleView: UILabel!
    @IBOutlet weak var articleDescView: UILabel!
    @IBOutlet weak var articleDateView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
       
        article.isBookmark = !article.isBookmark
       
        delegate?.bookmarkTapped(on: article)
    }
    
    func set(article: Article) {
        self.article = article
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        var date = Date()
        var dateStr = ""
        if let str = article.publishedAt {
            
            date = dateFormatter.date(from: str) ?? Date()
            dateFormatter.dateFormat = "dd MMM, YYYY"
            dateStr = dateFormatter.string(from: date)
        }
        
        articleTitleView?.text = article.title
        articleDescView?.text = article.articleDescription
        articleDescView.backgroundColor = .clear
        articleDateView?.text = dateStr
        if let url = article.urlToImage {
            articleImageView?.loadImageUsingCache(withUrl: url)
        }
        
    }
    
}
