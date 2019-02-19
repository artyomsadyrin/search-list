//
//  ResultsGetter.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/18/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResultsGetter
{
    private var currentDataTask: URLSessionTask?
    private var searchShouldEndObserver: NSObjectProtocol?
    
    func getJSONFromSearchResults(for inputForSearch: String, completionHandler: @escaping (String?) -> Void) {
        
        // apiKey and searchEngineId is a private information and not allowed to use without permission. To get yours please visit https://developers.google.com/custom-search/v1/overview
        let apiKey = "AIzaSyBOjLBG5EgXokhtMXjkGfmnQi2gzI2ydO0"
        let bundleId = "io.github.artyomsadyrin.Search-List"
        let searchEngineId = "013192253000657877849:nt00ris8vlw"
        // Index of the first result to return from the search
        let startIndex = String(6)
        let numberOfReturningResults = String(5)
        let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@&start=%@&num=%@", inputForSearch, searchEngineId, apiKey, startIndex, numberOfReturningResults)
        
        
        let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalUrl = URL(string: url!)
        let request = NSMutableURLRequest(url: finalUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            let session = URLSession.shared
            
            // Get a JSON from the Custom Search JSON API
            let datatask = session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
                
                self?.searchShouldEndObserver = NotificationCenter.default.addObserver(
                    forName: .SearchShouldEnd,
                    object: nil,
                    queue: nil,
                    using: { notification in
                        self?.currentDataTask?.cancel()
                })
                
                if let error = error {
                    print("Error:\n\(error.localizedDescription)")
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .SearchDidEnd, object: nil)
                        completionHandler(error.localizedDescription)
                    }
                } else {
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)!
                    print("JSON Result\n\(String(describing: dataString))")
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .SearchDidEnd, object: nil)
                        completionHandler(dataString)
                        if let observer = self?.searchShouldEndObserver {
                            NotificationCenter.default.removeObserver(observer)
                        }
                    }
                }
            }
            self?.currentDataTask = datatask
            datatask.resume()
        }
    }
}

extension Notification.Name {
    static let SearchDidEnd = Notification.Name("SearchDidEnd")
}
