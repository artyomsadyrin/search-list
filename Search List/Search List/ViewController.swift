//
//  ViewController.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/18/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        inputForSearchTextField.delegate = self
    }
    
    // MARK: Properties
    
    @IBOutlet weak var inputForSearchTextField: UITextField!
    
    @IBOutlet weak var googleSearchButtonOutlet: UIButton!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private var tempData = ["link 1 from search result", "link 2 from search result", "link 3 from search result"]
    
    private var searchResults = [String]()
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SearchResultTableViewCell.")
        }
        
        let link = searchResults[indexPath.row]
        
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
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Search failed",
            message: "Couldn't read text from search field",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default
        ))
        
        present(alert, animated: true)
    }
    
    // MARK: Search Actions
    
    @IBAction func googleSearchButton(_ sender: UIButton) {
        startSearch(for: inputForSearchTextField)
    }
    
    private func startSearch(for inputForSearch: UITextField) {
        searchResults = [String]()
        if let inputForSearch = inputForSearchTextField.text?.lowercased() {
            for value in tempData {
                if value.lowercased().contains(inputForSearch) {
                    searchResults.append(value)
                }
            }
            print("Data: \(tempData), Result: \(searchResults), parameter: \(inputForSearch)")
            
            
        } else {
            showErrorAlert()
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


