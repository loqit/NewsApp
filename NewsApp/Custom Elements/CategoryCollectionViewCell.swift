//
//  CategoryCollectionViewCell.swift
//  NewsApp
//
//  Created by Андрей Бобр on 18.01.21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    private let categoryButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtons() {
        
        categoryButton.backgroundColor = .orange
        contentView.addSubview(categoryButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryButton.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryButton.titleLabel?.text = nil
    }
    
    func set(category: Category) {
        categoryButton.setTitle(category.rawValue, for: .normal)
    }
}
