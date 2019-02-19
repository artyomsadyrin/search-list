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
    func getJSONFromSearchResults(for inputForSearch: String, completionHandler: @escaping (String?) -> Void) {
        
        // apiKey and searchEngineId is a private information and not allowed to use without permission. To get yours please visit https://developers.google.com/custom-search/v1/overview
        let apiKey = "AIzaSyBOjLBG5EgXokhtMXjkGfmnQi2gzI2ydO0"
        let bundleId = "io.github.artyomsadyrin.Search-List"
        let searchEngineId = "013192253000657877849:nt00ris8vlw"
        let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@","\(inputForSearch)", searchEngineId, apiKey)
        
        let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalUrl = URL(string: url!)
        let request = NSMutableURLRequest(url: finalUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        let session = URLSession.shared
        
        // Get a JSON from the Custom Search JSON API
        let datatask = session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    completionHandler(error.localizedDescription)
                }
            } else {
                let dataString = String(data: data!, encoding: String.Encoding.utf8)!
                print("JSON Result\n\(String(describing: dataString))")
                DispatchQueue.main.async {
                    completionHandler(dataString)
                }
            }
        }
        datatask.resume()
    }
}
