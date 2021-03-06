//
//  DRTableViewController.swift
//  DigitReader
//
//  Created by Pranay Suresh Pawar on 19/06/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit

class DRTableViewController: UITableViewController,XMLParserDelegate {

    var activityIndicator: UIActivityIndicatorView!
    var dparser:XMLParser = XMLParser()
    var showArts:[ShowArt] = []
    var showTitle:String = String()
    var showLink:String = String()
    var eName:String = String()
    var showAuthor:String = String()
    var showImageURL:String = String()
    var showDescription:String = String()
    let imageCache = NSCache<NSString,UIImage>()
    var feedItems:[FeedItem] = []
    var showDate:Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        view.addSubview(activityIndicator)
        
        CoreDataManager.sharedInstance.getDigitFeedFromDatabase(success: { (feedItemsFromDB) in
            
            feedItems.removeAll()
            
            feedItems = feedItemsFromDB.sorted(by: {$0.date > $1.date})
            
            self.tableView.reloadData()
            
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            
        }, failure: { (String) in
            
        })
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let url:URL = URL(string: "https://feeds.feedburner.com/digit/latest-news")!
        dparser = XMLParser(contentsOf: url)!
        dparser.delegate = self
        dparser.parse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
      return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DRTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DRTableViewCell", for: indexPath) as! DRTableViewCell
        
        let feedItem:FeedItem = feedItems[indexPath.row]
        
        cell.showTitle.text = feedItem.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        
        let pubDate = Date(timeIntervalSince1970: TimeInterval(feedItem.date))
        
        let displayDate = dateFormatter.string(from: pubDate)
        
        //cell.showDate.text = displayDate.description
        cell.showDate.isHidden = true
        
        //let results = feedItem.author?.range(of: "\\((.*?)\\)",options: .regularExpression)
        //let showAuthor : String = feedItem.author!.substring(with: results!)
        //cell.showAuthor.text = " - " + showAuthor.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        
        cell.showAuthor.text = displayDate.description
        cell.showImage.downloadImage(from: feedItem.imageURL!) 
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        
        let feedItem:FeedItem = feedItems[indexPath.row]
        
        
        postViewController.showLink = feedItem.link!
        postViewController.itemTitle = feedItem.title!
        
        self.navigationController?.pushViewController(postViewController, animated: true)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "viewpost" {
            
            
            let feedItem:FeedItem = feedItems[(tableView.indexPathForSelectedRow?.row)!]
            
            let viewController = segue.destination as! PostViewController
            
            viewController.showLink = feedItem.link!
            viewController.itemTitle = feedItem.title!
            
        }
    }*/
    

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        eName = elementName
        
        switch elementName {
            
        case "item":
            showTitle = String()
            showLink = String()
            showAuthor = String()
            showDescription = String()
        case "media:thumbnail":
            
            if let urlString = attributeDict["url"] {
                showImageURL = urlString
            } else {
                print("malformed element: media:thumbnail without url attribute")
            }
            
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            if eName == "title" {
                showTitle += data
            } else if eName == "link" {
                showLink += data
            } else if eName == "author" {
                showAuthor += data
            } else if eName == "description" {
                
                do {
                    let regex:NSRegularExpression = try NSRegularExpression(pattern: "<.*?>", options: NSRegularExpression.Options.caseInsensitive)
                    
                    let range = NSMakeRange(0, data.characters.count)
                    let description : String = regex.stringByReplacingMatches(in: data, options: [], range: range, withTemplate: "")
                    
                    showDescription += description
                } catch {
                    
                }
                
            } else if eName == "pubDate" {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                let dateString = data
                
                let date = dateFormatter.date(from: dateString)
                showDate = Int64((date?.timeIntervalSince1970)!)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let showArt:ShowArt = ShowArt()
            showArt.showTitle = showTitle
            showArt.showLink = showLink
            showArt.showAuthor = showAuthor
            showArt.showDescription = showDescription
            showArt.showImageURL = showImageURL
            showArt.showDate = showDate
            showArts.append(showArt)
        } else if elementName == "media:thumbnail" {
            
            //showArts.first?.showImageURL = showImageURL
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        activityIndicator.startAnimating()
        showArts.removeAll()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        
        CoreDataManager.sharedInstance.saveDigitFeedToDatabase(feedItems: showArts, success: { (String) in
            
            CoreDataManager.sharedInstance.getDigitFeedFromDatabase(success: { (feedItemsFromDB) in
                
                feedItems.removeAll()
                
                feedItems = feedItemsFromDB.sorted(by: {$0.date > $1.date})
                
                self.tableView.reloadData()
                
            }, failure: { (String) in
                
            })
            
        }, failure: { (String) in
            
        })
        
    }
    
}
