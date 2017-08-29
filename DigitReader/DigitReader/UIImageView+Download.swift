//
//  UIImageView+Download.swift
//  DigitReader
//
//  Created by Pranay Suresh Pawar on 25/06/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    
    func downloadImage(from imgURL:String) {
        
         image = nil
        
        
        if imgURL == "" {
            return
        }
        
        let url:URL = URL(string: imgURL)!
        
        if let imageToCache = imageCache.object(forKey: imgURL as NSString){
            
            self.image = imageToCache
            
            return
        }
        
        
        let task = URLSession.shared.downloadTask(with: url, completionHandler: {(location, response, error) -> Void in
        
            if let data = try? Data(contentsOf: url) {
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    
                    imageCache.setObject(imageToCache!, forKey: imgURL as NSString)
                    
                    self.image = imageToCache
                    
                    
                }
            }
            
        })

        task.resume()
        
        
        
    }
}
		
