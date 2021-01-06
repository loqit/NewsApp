//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Андрей Бобр on 7.01.21.
//

import UIKit

class ArticleCell: UITableViewCell {

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
    
    @IBAction func addToFav(_ sender: UIButton) {
    }
    
    func set(article: Article) {
        
        articleTitleView?.text = article.title
        articleDescView?.text = article.articleDescription
        articleDescView.backgroundColor = .clear
        articleDateView?.text = article.publishedAt
        if let url = article.urlToImage {
            articleImageView?.loadImageUsingCache(withUrl: url)
        }
        
    }
    
}
