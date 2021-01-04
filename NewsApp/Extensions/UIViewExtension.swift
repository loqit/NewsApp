//
//  UIViewExtension.swift
//  NewsApp
//
//  Created by Андрей Бобр on 3.01.21.
//

import UIKit

extension UIView {
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints                             = false
        //topAnchor.constraint(equalTo: superView.topAnchor).isActive           = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 90.0).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive   = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive     = true
        
    }
}
