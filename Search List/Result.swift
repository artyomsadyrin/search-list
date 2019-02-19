//
//  Result.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/19/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Result {
    let inputForSearch: String
    var link: [String]?
    var failed: Bool
    
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
            
            if let data = jsonResults.data(using: .utf8) {
                if let json = try? JSON(data: data) {
                    let linksFromJSON = json["items"].arrayValue.map{ $0["link"].stringValue }
                    self.link = linksFromJSON
                    if let linksForPrint = self.link {
                        print("Links:\n\(linksForPrint.joined(separator: "\n"))")
                        //self.delegate?.updateCityTable()
                    }
                }
            }
        }
    }
    
}

