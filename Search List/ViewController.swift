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
    
    @IBOutlet weak var googleSearchButtonOutlet: UIButton! {
        didSet {
            searchEndObserver = NotificationCenter.default.addObserver(
                forName: .SearchDidEnd,
                object: nil,
                queue: OperationQueue.main,
                using: { notification in
                    self.googleSearchButtonOutlet.setTitle("Google Search", for: [])
            }
            )
        }
    }
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private var result: Result?
    
    private var searchEndObserver: NSObjectProtocol?
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.links?.count ?? 1
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
    
    // Hide keyboard by press a return button and starting a search
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch(for: textField)
        return true
    }
    
    // MARK: General Methods
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let observer = searchEndObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
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
        //updateSearchResultTableView()
    }
    
    // MARK: Custom Delegate
    
    func updateSearchResultTableView() {
        searchResultTableView.reloadData()
    }
    
    // MARK: Search Actions
    
    @IBAction func googleSearchButton(_ sender: UIButton) {
        startSearch(for: inputForSearchTextField)
    }
    
    // Check for valid & empty string and init model
    private func startSearch(for inputForSearch: UITextField) {
        googleSearchButtonOutlet.setTitle("Stop", for: [])
        
        if let inputForSearch = inputForSearchTextField.text {
            let inputWithoutWhipespaces = inputForSearch.trimmingCharacters(in: .whitespacesAndNewlines)
            if !inputWithoutWhipespaces.isEmpty {
                result = Result(for: inputWithoutWhipespaces)
                result?.delegate = self
            } else {
                showErrorAlert(errorCode: "400")
            }
        }
    }
}

// MARK: Extenstions

extension UIButton
{
    // Made a "Google Search" button a little rounding and add border
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

extension Notification.Name {
    static let SearchDidStart = Notification.Name("SearchDidStart")
}
