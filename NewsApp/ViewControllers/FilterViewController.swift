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
    
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var languageField: UITextField!
    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var sortField: UITextField!
    
    var countryPeakerView = UIPickerView()
    var categoryPeakerView = UIPickerView()
    var languagePeakerView = UIPickerView()
    var sortPeakerView = UIPickerView()
    var sourcePeakerView = UIPickerView()
    
    let fromDatePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()
    
    private var requestOptions = RequestOptions()
    
    // weak used in order to avoid retain circle
    // Delegate connect RootViewController and FilterViewController
    weak var delegate: OptionsDelegate?
    
    // Array of all available sources
    private var sourcesData = [FullSource]()
    private var service: SourceProtocol?
    
    // PickerView Identifier
    static var pickerIdentifier = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filters"
        configurePikers()
        configureLables()
        configureDatePickers()
        configureNavController()
        fetchSources()
    }
    
    func configureNavController() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(applyOptions))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelOptions))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc
    func applyOptions() {
        
        navigationController?.popViewController(animated: true)
        delegate?.setOptions(with: requestOptions)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func cancelOptions() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func configureLables() {
        headlineLable.text = "Top Headline options"
        everythingLable.text = "Everything options"
    }
    
    static func getUniqueIdentifier() -> Int {
        pickerIdentifier += 1
        return pickerIdentifier
    }
    
    func configureDatePickers() {
        fromDatePicker.setupDatePicker(textField: fromField, selector: #selector(doneFromPressed))
        toDatePicker.setupDatePicker(textField: toField, selector: #selector(doneToPressed))
    }
    

    @objc
    func doneFromPressed() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        fromField.text = formatter.string(from: fromDatePicker.date)
        requestOptions.from = "\(fromDatePicker.date)"
        view.endEditing(true)
    }
    
    @objc
    func doneToPressed() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        toField.text = formatter.string(from: toDatePicker.date)
        requestOptions.to = "\(toDatePicker.date)"
        view.endEditing(true)
    }
    
    func configurePikers() {
        
        setTextFieldStyle(textField: countryField, text: "Contry")
        setTextFieldStyle(textField: categoryField, text: "Category")
        setTextFieldStyle(textField: languageField, text: "Language")
        setTextFieldStyle(textField: sortField, text: "Sorting")
        setTextFieldStyle(textField: sourceField, text: "Source")
        setTextFieldStyle(textField: fromField, text: "from date")
        setTextFieldStyle(textField: toField, text: "to date")
        
        setPickerViewDelegates(pickerView: sourcePeakerView, textField: sourceField)

        setPickerViewDelegates(pickerView: countryPeakerView, textField: countryField)
        
        setPickerViewDelegates(pickerView: categoryPeakerView, textField: categoryField)
        setPickerViewDelegates(pickerView: languagePeakerView, textField: languageField)
        setPickerViewDelegates(pickerView: sortPeakerView, textField: sortField)

        
    }
    
    func setTextFieldStyle(textField: UITextField, text: String) {
        textField.placeholder = "Select " + text
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        
    }
    
    func setPickerViewDelegates(pickerView: UIPickerView, textField: UITextField) {
        textField.inputView = pickerView
        textField.textAlignment = .center
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = FilterViewController.getUniqueIdentifier()
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
        case sourcePeakerView.tag:
            return sourcesData.count
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
        case sourcePeakerView.tag:
            return sourcesData[row].name
        default:
            return "Not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case countryPeakerView.tag:
            let items = Country.allCases.map { $0.rawValue }
            requestOptions.country = Country(rawValue: items[row]) ?? .none
            countryField.text = countryName(countryCode: items[row])
            countryField.resignFirstResponder()
        case categoryPeakerView.tag:
            let items = Category.allCases.map { $0.rawValue }
            requestOptions.category = Category(rawValue: items[row])
            categoryField.text = items[row]
            categoryField.resignFirstResponder()
        case languagePeakerView.tag:
            let items = Language.allCases.map { $0.rawValue }
            requestOptions.language = Language(rawValue: items[row]) ?? .en
            languageField.text = items[row]
            languageField.resignFirstResponder()
        case sortPeakerView.tag:
            let items = Sorting.allCases.map { $0.rawValue }
            requestOptions.sortBy = Sorting(rawValue: items[row]) ?? .publishedAt
            sortField.text = items[row]
            sortField.resignFirstResponder()
        case sourcePeakerView.tag:
            requestOptions.source = sourcesData[row].id ?? ""
            sourceField.text = sourcesData[row].name
            sourceField.resignFirstResponder()
        default:
            return 
        }
    }
    
    
    
}
// MARK: - Fetch all available sources
extension FilterViewController {
    func fetchSources() {
        self.service = SourceService()
        DispatchQueue.global().async {
            self.service?.fetchSources(country: "", category: nil, language: "") { result in
                switch result {
                case .success(let sources):
                    let data = sources.sources ?? []
                    self.updateSources(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateSources(with data: [FullSource]) {
        DispatchQueue.main.async {
            self.sourcesData = data
            self.sourcePeakerView.reloadAllComponents()
            self.sourcePeakerView.reloadInputViews()
        }
    }
}
