//
//  ResultsGetter.swift
//  Search List
//
//  Created by Artyom Sadyrin on 2/18/19.
//  Copyright © 2019 Artyom Sadyrin. All rights reserved.
//

import Foundation

class SearchResultsGetter
{
    private var currentDataTask: URLSessionTask?
    private var searchShouldEndObserver: NSObjectProtocol?
    
    func getJSONFromSearchResults(for inputForSearch: String, start: Int, completionHandler: @escaping (Result<String, NSError>) -> Void) {
        
        // apiKey and searchEngineId is a private information and not allowed to use without permission. To get yours please visit https://developers.google.com/custom-search/v1/overview
        #error("Need to add your API Key")
        let apiKey = ""
        let bundleId = "io.github.artyomsadyrin.Search-List"
        #error("Need to add your Search Engine ID")
        let searchEngineId = ""
        // Index of the result from the search. Max = 100
        let startIndex = String(start)
        let numberOfReturningResults = String(1)
        let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@&start=%@&num=%@", inputForSearch, searchEngineId, apiKey, startIndex, numberOfReturningResults)
        
        
        let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalUrl = URL(string: url!)
        let request = NSMutableURLRequest(url: finalUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
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
                
                if let error = error as NSError? {
                    let postedError: [String: NSError] = [error.localizedDescription: error]
                    print("Error:\n\(String(describing: postedError.keys.first))")
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                        NotificationCenter.default.post(name: .SearchDidEnd, object: nil)
                        NotificationCenter.default.post(name: .ErrorInRequestIsHappened, object: nil, userInfo: postedError)
                    }
                } else {
                    if let data = data {
                        if let dataString = String(data: data, encoding: String.Encoding.utf8) {
                            print("JSON Result\n\(String(describing: dataString))")
                            print("ResultGetter Current Thread: \(Thread.current)")
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .SearchDidEnd, object: nil)
                                completionHandler(.success(dataString))
                            }
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
    static let ErrorInRequestIsHappened = Notification.Name("ErrorInRequestIsHappened")
}
