//
//  FilterViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 8.01.21.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var headlineLable: UILabel!
    @IBOutlet weak var everythingLable: UILabel!
    @IBOutlet weak var commonLable: UILabel!
    
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var languageField: UITextField!
    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var sortField: UITextField!
    @IBOutlet weak var pageSizeField: UITextField!
    
    var countryPeakerView = UIPickerView()
    var categoryPeakerView = UIPickerView()
    var languagePeakerView = UIPickerView()
    var sortPeakerView = UIPickerView()
    
    let fromDatePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()
    
    static var pickerIdentifier = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filters"
        configurePikers()
        configureLables()
        configureDatePickers()
    }
    
    func configureLables() {
        headlineLable.text = "Top Headline options"
        everythingLable.text = "Everything options"
        commonLable.text = "Commom options"
    }
    
    static func getUniqueIdentifier() -> Int {
        pickerIdentifier += 1
        return pickerIdentifier
    }
    
    func configureDatePickers() {
        fromDatePicker.setupDatePicker(name: "from", textField: fromField, selector: #selector(doneFromPressed))
        toDatePicker.setupDatePicker(name: "to", textField: toField, selector: #selector(doneToPressed))
    }
    

    @objc
    func doneFromPressed() {
        fromField.text = "\(fromDatePicker.date)"
        view.endEditing(true)
    }
    
    @objc
    func doneToPressed() {
        toField.text = "\(toDatePicker.date)"
        view.endEditing(true)
    }
    
    func configurePikers() {

        countryField.placeholder = "Select Country"
        categoryField.placeholder = "Select Category"
        languageField.placeholder = "Select Language"
        sortField.placeholder = "Select Sorting"
        
        setPickerViewDelegates(pickerView: countryPeakerView, textField: countryField)
        setPickerViewDelegates(pickerView: categoryPeakerView, textField: categoryField)
        setPickerViewDelegates(pickerView: languagePeakerView, textField: languageField)
        setPickerViewDelegates(pickerView: sortPeakerView, textField: sortField)
        
    }
    
    func setPickerViewDelegates(pickerView: UIPickerView, textField: UITextField) {
        textField.inputView = pickerView
        textField.textAlignment = .center
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = FilterViewController.getUniqueIdentifier()
    }
    
    private func setOptions(with requestOptions: RequestOptions) {
        // TopHeadlines
        // country(choose), category(choose)
        
        // Everything
        // from(enter), to(enter), language(choose), sortBy(choose), source(choose)
        
        // Common
        // pageSize(enter)
        
        // return struct with this options (RequestOptions)
    }
    func countryName(countryCode: String) -> String? {
       // let lang = Language.getCurrLanguage()
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }

}
 
extension FilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case countryPeakerView.tag:
            return Country.allCases.count
        case categoryPeakerView.tag:
            return Category.allCases.count
        case languagePeakerView.tag:
            return Language.allCases.count
        case sortPeakerView.tag:
            return Sorting.allCases.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case countryPeakerView.tag:
            let items = Country.allCases.map { $0.rawValue }
            return countryName(countryCode: items[row])
        case categoryPeakerView.tag:
            let items = Category.allCases.map { $0.rawValue }
            return items[row]
        case languagePeakerView.tag:
            let items = Language.allCases.map { $0.rawValue }
            return items[row]
        case sortPeakerView.tag:
            let items = Sorting.allCases.map { $0.rawValue }
            return items[row]
        default:
            return "Not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case countryPeakerView.tag:
            let items = Country.allCases.map { $0.rawValue }
            countryField.text = countryName(countryCode: items[row])
            countryField.resignFirstResponder()
        case categoryPeakerView.tag:
            let items = Category.allCases.map { $0.rawValue }
            categoryField.text = items[row]
            categoryField.resignFirstResponder()
        case languagePeakerView.tag:
            let items = Language.allCases.map { $0.rawValue }
            languageField.text = items[row]
            languageField.resignFirstResponder()
        case sortPeakerView.tag:
            let items = Sorting.allCases.map { $0.rawValue }
            sortField.text = items[row]
            sortField.resignFirstResponder()
        default:
            return 
        }
    }
    
    
    
}
