//
//  ViewController.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/18/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ResultDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        inputForSearchTextField.delegate = self
    }
    
    // MARK: Properties
    
    private let resultGetter = ResultsGetter()
    
    @IBOutlet weak var inputForSearchTextField: UITextField!
    
    @IBOutlet weak var googleSearchButtonOutlet: UIButton!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private var result: Result?
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.totalResults ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SearchResultTableViewCell.")
        }
        
        let link = result?.links?[indexPath.row]
        
        cell.linkLabel.text = link
        
        return cell
    }
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch(for: textField)
        return true
    }
    
    // MARK: General Methods
    
    private func showErrorAlert(errorCode: String) {
        if errorCode == "400" {
            let alert = UIAlertController(
                title: "Search failed",
                message: "Couldn't read text from the search field",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default
            ))
            
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Search failed",
                message: "Couldn't read text from the search field",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default
            ))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSearchResultTableView()
    }
    
    func updateSearchResultTableView() {
        searchResultTableView.reloadData()
    }
    
    // MARK: Search Actions
    
    @IBAction func googleSearchButton(_ sender: UIButton) {
        startSearch(for: inputForSearchTextField)
    }
    
    private func startSearch(for inputForSearch: UITextField) {
        if let inputForSearch = inputForSearchTextField.text, !inputForSearch.isEmpty {
            result = Result(for: inputForSearch)
            result?.delegate = self
        } else {
            showErrorAlert(errorCode: "400")
        }
        searchResultTableView.reloadData()
    }
}


extension UIButton
{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


