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
    func getResults(for inputForSearch: String, completion: @escaping (String?) -> Void) {
        
        let apiKey = "AIzaSyBOjLBG5EgXokhtMXjkGfmnQi2gzI2ydO0"
        let bundleId = "io.github.artyomsadyrin.Search-List"
        let searchEngineId = "013192253000657877849:nt00ris8vlw"
        let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@","\(inputForSearch)",searchEngineId, apiKey)
        
        
        let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalUrl = URL(string: url!)
        let request = NSMutableURLRequest(url: finalUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        let session = URLSession.shared
        
        let datatask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                    print("asyncResult\(jsonResult)")
                }
                
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        datatask.resume()
        
        
    }
 
}
