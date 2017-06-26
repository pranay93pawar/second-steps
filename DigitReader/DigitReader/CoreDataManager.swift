//
//  CoreDataManager.swift
//  DigitReader
//
//  Created by Pranay Suresh Pawar on 26/06/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager  {
    
    static let sharedInstance = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveDigitFeedToDatabase(feedItems:[ShowArt],success:(_ response:String) -> Void,failure:(_ error:String)-> Void) {
        
        deleteEntity(entityName: "FeedItem", success: { (String) in
            
            for feedItem in feedItems {
                
                let entity = NSEntityDescription.entity(forEntityName: "FeedItem", in: context)
                
                let feedItemEntity = NSManagedObject(entity: entity!, insertInto: context) as! FeedItem
                
                
                feedItemEntity.title = feedItem.showTitle
                feedItemEntity.desc = feedItem.showDescription
                feedItemEntity.author = feedItem.showAuthor
                feedItemEntity.link = feedItem.showLink
                feedItemEntity.imageURL = feedItem.showImageURL
                
            }
            
            do {
                try context.save()
                success("Success")
            } catch  {
                failure("failure")
            }
            
            
        }, failure: { (NSError) in
            
        })
        
    }
    
    
    func getDigitFeedFromDatabase(success:(_ response:Array<FeedItem>)->Void,failure:(_ error:String)->Void) {
        
        let fetchRequests = NSFetchRequest<NSFetchRequestResult>(entityName: "FeedItem")
        
        var fetchRequestResults = [FeedItem]()
        
        
        do {
            try fetchRequestResults = context.fetch(fetchRequests) as! [FeedItem]
        } catch  {
            failure("failure")
        }
        
        
        if fetchRequestResults.count > 0 {
            success(fetchRequestResults)
        } else {
            failure("failure")
        }
    }
    
    
    func deleteEntity(entityName:String,success:(_ response:String)->Void,failure:(_ error:NSError)->Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results {
                
                context.delete(result as! NSManagedObject)
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save \(error) , \(error.userInfo)")
                }
                
            }
            
            success("Success")
            
        } catch let error as NSError {
            failure(error)
        }
        
        
        
    }
    
}
