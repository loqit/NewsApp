//
//  DatePickerExtension.swift
//  NewsApp
//
//  Created by Андрей Бобр on 14.01.21.
//

import Foundation
import UIKit

extension UIDatePicker {
    
    func setupDatePicker(name: String, textField: UITextField, selector: Selector) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: selector)
        toolbar.setItems([doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        textField.placeholder = name
        textField.textAlignment = .center
        textField.inputView = self
        
        self.maximumDate = .some(Date())
        self.datePickerMode = .date
        self.preferredDatePickerStyle = .wheels
    }
}
