//
//  ViewController.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/18/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        
    }

    // MARK: Properties
    
    @IBOutlet weak var inputForSearchTextField: UITextField!
    
    @IBOutlet weak var googleSearchButtonOutlet: UIButton!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private var searchResults = ["link 1 from search result", "link 2 from search result", "link 3 from search result"]
    
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
    
    // MARK: Search Actions
    
    @IBAction func googleSearchButton(_ sender: UIButton) {
        
        
        
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


