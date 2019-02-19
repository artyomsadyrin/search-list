//
//  Result.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/19/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ResultDelegate: class {
    func updateSearchResultTableView()
}

class Result
{
    // MARK: Properties
    
    let inputForSearch: String
    var links: [String]?
    var totalResults: Int?
    var isFailed: Bool
    weak var delegate: ResultDelegate?
    //private var searchShouldEndObserver: NSObjectProtocol?
    
    //MARK: Init
    
    init(for inputForSearch: String) {
        self.inputForSearch = inputForSearch
        isFailed = false
        getSearchResults(for: inputForSearch)
    }
    
    //MARK: Instance methods
    
    private func getSearchResults(for inputForSearch: String) {
        
        let resultGetter = ResultsGetter()
        
        resultGetter.getJSONFromSearchResults(for: inputForSearch) { (jsonResults) in
            guard let jsonResults = jsonResults else {
                self.isFailed = true
                return
            }
    
            // TO-DO: Do I need change some properties to nil here?
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // Read JSON from the Custom Search JSON API and set a model's properties
                if let data = jsonResults.data(using: .utf8) {
                    if let json = try? JSON(data: data) {
                        print("Input for search: --\(String(describing: self?.inputForSearch))--")
                        // In case if i will need totalResults from API
                        let totalResultsFromJSON = json["searchInformation"]["totalResults"].stringValue
                        if let totalResultsInInt = Int(totalResultsFromJSON) {
                            self?.totalResults = totalResultsInInt
                            print("Total Results: \(String(describing: self?.totalResults))")
                        } else {
                            print("Can't get total results.")
                        }
                        
                        let linksFromJSON = json["items"].arrayValue.map{ $0["link"].stringValue }
                        self?.links = linksFromJSON
                        DispatchQueue.main.async {
                            self?.delegate?.updateSearchResultTableView()
                        }
                        print("Links:\n\(String(describing: self?.links))\nLinks Count: \(String(describing: self?.links?.count))")
                    }
                }
            }
        }
        
    }
}

