//
//  Repo.swift
//  DigitReader
//
//  Created by Mac-145-Pranay-Pawar on 28/10/19.
//  Copyright © 2019 Pranay Suresh Pawar. All rights reserved.
//

import Foundation

struct Repo {
    let id: Int64
    let name: String
    let language: String?
    
    init?(dict: [String: Any]) {
        
        guard let id = dict["id"] as? Int64,
                let name = dict["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.language = dict["language"] as? String
    }
    
    init(_ id:Int64, _ name:String, _ languange:String) {
        self.id = id
        self.name = name
        self.language = languange
    }
}
