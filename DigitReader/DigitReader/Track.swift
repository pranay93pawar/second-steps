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
    
    init(name:String,artist:String,previewURL:URL,index:Int) {
        
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
        
    }
    
}
