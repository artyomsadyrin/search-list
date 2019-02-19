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
    let inputForSearch: String
    var links: [String]?
    var totalResults: Int?
    var failed: Bool
    weak var delegate: ResultDelegate?
    
    init(for inputForSearch: String) {
        self.inputForSearch = inputForSearch
        failed = false
        getSearchResults(for: inputForSearch)
    }
    
    func getSearchResults(for inputForSearch: String) {
        
        let resultGetter = ResultsGetter()
        
        resultGetter.getJSONFromSearchResults(for: inputForSearch) { (jsonResults) in
            guard let jsonResults = jsonResults else {
                self.failed = true
                return
            }
            
            // Read JSON from the Custom Search JSON API and set a model's properties
            if let data = jsonResults.data(using: .utf8) {
                if let json = try? JSON(data: data) {
                    
                    let totalResultsFromJSON = json["searchInformation"]["totalResults"].stringValue
                    if let totalResultsInInt = Int(totalResultsFromJSON) {
                        // Temp solution
                        self.totalResults = 10
                        //self.totalResults = totalResultsInInt
                        self.delegate?.updateSearchResultTableView()
                        print("Total Results: \(String(describing: self.totalResults))")
                    } else {
                        print("Can't get total results.")
                    }
                    
                    let linksFromJSON = json["items"].arrayValue.map{ $0["link"].stringValue }
                    self.links = linksFromJSON
                    self.delegate?.updateSearchResultTableView()
                    print("Links:\n\(String(describing: self.links))")
            }
        }
    }
    
}
}

