//
//  QueryService.swift
//  DigitReader
//
//  Created by LT-145-PRANAY-PAWAR on 30/08/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import Foundation

class  QueryService {
    
    
    typealias JSONDirectory = [String: Any]
    typealias QueryResult = ([Track]? , String) -> ()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask?
    
    var tracks : [Track] = []
    var errorMessage : String = ""
    
    
    func getSearchResults(searchTerm:String, completion:@escaping QueryResult) {
        
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            
            guard let url = urlComponents.url else { return }
            
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                
                defer { self.dataTask = nil }
                
                if let error = error {
                    
                    self.errorMessage  += "DataTask error: " + error.localizedDescription + "\n"
                    
                } else if let data = data , let response = response as? HTTPURLResponse , response.statusCode == 200 {
                    
                    self.updateSearchResults(data: data)
                    
                    DispatchQueue.main.async {
                       
                        completion(self.tracks, self.errorMessage)
                    }
                    
                }
                
                
            }
            
            dataTask?.resume()
        }
    }
    
    
    fileprivate func updateSearchResults(data:Data){
        
        var response:JSONDirectory?
        tracks.removeAll()
        
        
        do {
            try response = JSONSerialization.jsonObject(with: data, options: []) as? JSONDirectory
        } catch let error as NSError {
            errorMessage += "JSONSerialization error \(error.localizedDescription)"
            return
        }
        
        
        guard let results = response!["results"] as? [Any] else {
            errorMessage += "response does not contains search results"
            return
        }
        
        var index = 0
        
        for trackDict in results {
         
            if let trackDict = trackDict as? JSONDirectory,
            let name = trackDict["trackName"] as? String,
            let artist = trackDict["artistName"] as? String,
            let previewUrlString = trackDict["previewUrl"] as? String,
            let previewURL = URL(string: previewUrlString){
                tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
                index += 1
            } else {
                errorMessage = "problem parsing trackDictionary"
            }
        }
        
    }
    
    
}
