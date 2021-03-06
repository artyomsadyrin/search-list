//
//  ViewController.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/18/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SearchResultDelegate
{
    
    // MARK: Properties
    
    enum searchFailedError: Error {
        case badInput
    }
    
    @IBOutlet weak var inputForSearchTextField: UITextField!
    
    @IBOutlet weak var googleSearchButtonOutlet: UIButton! {
        didSet {
            searchDidEndObserver = NotificationCenter.default.addObserver(
                forName: .SearchDidEnd,
                object: nil,
                queue: OperationQueue.main,
                using: { notification in
                    self.googleSearchButtonOutlet.setTitle("Google Search", for: [])
            })
        }
    }
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private var result: SearchResult? = nil
    
    private let countOfRequests = 2
    
    private var searchDidEndObserver: NSObjectProtocol?
    private var searchShouldEndObserver: NSObjectProtocol?
    private var errorInRequestObserver: NSObjectProtocol?
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.links.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SearchResultTableViewCell.")
        }
        let link = result?.links[indexPath.row]
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        inputForSearchTextField.delegate = self
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that "done" button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.inputForSearchTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonAction() {
        inputForSearchTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let searchDidEndObserver = searchDidEndObserver, let searchShouldEndObserver = searchShouldEndObserver, let errorInRequestObserver = errorInRequestObserver {
            NotificationCenter.default.removeObserver(searchDidEndObserver)
            NotificationCenter.default.removeObserver(searchShouldEndObserver)
            NotificationCenter.default.removeObserver(errorInRequestObserver)
        }
    }
    
    private func showNSErrorAlert(error: NSError) {
        let alert = UIAlertController(
            title: "Search failed",
            message: "Connection error: \(error.code)\n\(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default
        ))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(error: Error) {
        
        switch error {
            
        case searchFailedError.badInput:
            let alert = UIAlertController(
                title: "Search failed",
                message: "Couldn't read text from the search field. Try another keyword",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default
            ))
            present(alert, animated: true)
            
        default:
            let alert = UIAlertController(
                title: "Search failed",
                message: "\(error.localizedDescription)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default
            ))
            present(alert, animated: true)
            
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
        if sender.currentTitle == "Google Search" {
            startSearch(for: inputForSearchTextField)
        } else if sender.currentTitle == "Stop" {
            NotificationCenter.default.post(name: .SearchShouldEnd, object: nil)
            sender.setTitle("Google Search", for: [])
        }
    }
    
    // Check for valid & empty string and init model
    private func startSearch(for inputForSearch: UITextField) {
        googleSearchButtonOutlet.setTitle("Stop", for: [])
        
        errorInRequestObserver = NotificationCenter.default.addObserver(
            forName: .ErrorInRequestIsHappened,
            object: nil,
            queue: nil,
            using: { notification in
                if let error = notification.userInfo?.values.first as? NSError {
                    self.showNSErrorAlert(error: error)
                } else {
                    print("Can't read the error")
                }
        })
        
        if let inputForSearch = inputForSearchTextField.text {
            let inputWithoutWhipespaces = inputForSearch.trimmingCharacters(in: .whitespacesAndNewlines)
            if !inputWithoutWhipespaces.isEmpty {
                for startIndex in 1...countOfRequests {
                    result = SearchResult(for: inputWithoutWhipespaces, start: startIndex)
                    result?.delegate = self
                }
                searchShouldEndObserver = NotificationCenter.default.addObserver(
                    forName: .SearchShouldEnd,
                    object: nil,
                    queue: OperationQueue.main,
                    using: { notification in
                        self.searchResultTableView.reloadData()
                })
            }
            else {
                showErrorAlert(error: searchFailedError.badInput)
                NotificationCenter.default.post(name: .SearchDidEnd, object: nil)
            }
        } else {
            showErrorAlert(error: searchFailedError.badInput)
            NotificationCenter.default.post(name: .SearchDidEnd, object: nil)
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
    static let SearchShouldEnd = Notification.Name("SearchShouldEnd")
}
