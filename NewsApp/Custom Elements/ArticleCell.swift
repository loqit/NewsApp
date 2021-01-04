//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Андрей Бобр on 4.01.21.
//

import UIKit

class ArticleCell: UITableViewCell {

    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var dateTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToFav(_ sender: Any) {
    }
    
    func set(article: Article) {
        titleLable.text = article.title
        descText.text = article.articleDescription
        dateTitle.text = article.publishedAt
        if let link = article.urlToImage {
            cellImage.loadImageUsingCache(withUrl: link)
        }
    }
    
}
