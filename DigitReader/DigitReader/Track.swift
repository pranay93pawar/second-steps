//
//  Track.swift
//  DigitReader
//
//  Created by LT-145-PRANAY-PAWAR on 30/08/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import Foundation

class Track {
    
    
    let name:String
    let artist:String
    let previewURL:URL
    let index:Int
    var downloaded = false
    
    
    init?(dict: [String:Any]) {
        
        guard let name = dict["trackName"] as? String,
            let artist = dict["artistName"] as? String,
            let previewURL = dict["previewUrl"] as? String else {
                return nil
        }
        
        self.name = name
        self.artist = artist
        self.previewURL = URL(string: previewURL)!
        self.index = 0
    }
    
    init(name:String,artist:String,previewURL:URL,index:Int) {
        
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
        
    }
    
}
