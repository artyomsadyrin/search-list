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
    var links: [String?]
    weak var delegate: ResultDelegate?
    private var countOfRequests: Int
    private var nextPageStartIndex: Int?
    
    //MARK: Init
    
    init(for inputForSearch: String, start: Int) {
        self.inputForSearch = inputForSearch
        self.links = [String?]()
        self.countOfRequests = start
        for index in 0..<countOfRequests {
            getSearchResults(for: inputForSearch, searchIndex: index + 1)
        }
    }
    
    //MARK: Instance methods
    
    private func getSearchResults(for inputForSearch: String, searchIndex: Int) {
        
        let resultGetter = ResultsGetter()
        
        resultGetter.getJSONFromSearchResults(for: inputForSearch, start: searchIndex) { (jsonResults, error) in
            guard let jsonResults = jsonResults else {
                return
            }
            
            // TO-DO: Do I need change some properties to nil here?
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                // Read JSON from the Custom Search JSON API and set a model's properties
                if let data = jsonResults.data(using: .utf8) {
                    if let json = try? JSON(data: data) {
                        print("Input for search: --\(String(describing: self?.inputForSearch))--")
                        print("Reading from JSON Current Thread: \(Thread.current)")
                        
                        let nextPageStartIndexFromJSON = json["queries"]["nextPage"].arrayValue[0]["startIndex"].stringValue
                        if let nextPageStartIndexInInt = Int(nextPageStartIndexFromJSON) {
                            self?.nextPageStartIndex = nextPageStartIndexInInt
                            print("Next page start index: \(String(describing: self?.nextPageStartIndex))")
                        }
                        
                        let linksFromJSON = json["items"].arrayValue.map{ $0["link"].stringValue }
                        print("linkFromJSON: \(linksFromJSON)")
                        for link in linksFromJSON {
                            self?.links.append(link)
                            DispatchQueue.main.async {
                                self?.delegate?.updateSearchResultTableView()
                            }
                        }
                        print("Links:\n\(String(describing: self?.links))\nLinks Count: \(String(describing: self?.links.count))")
                    }
                }
            }
        }
        
    }
}

