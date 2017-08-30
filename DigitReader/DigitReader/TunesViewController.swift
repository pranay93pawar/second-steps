//
//  TunesViewController.swift
//  DigitReader
//
//  Created by LT-145-PRANAY-PAWAR on 29/08/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit

class TunesViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tunesTableView: UITableView!
    
    let queryService = QueryService()
    var searchResults : [Track] = []
    
    lazy var tapRecognizer:UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        return recognizer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Downloads"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func dissmissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let searchText = searchBar.text,  !searchText.isEmpty else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryService.getSearchResults(searchTerm: searchText){ results , errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                self.searchResults = results
                self.tunesTableView.reloadData()
            }
            
            if !errorMessage.isEmpty {print("search error : \(errorMessage)")}
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        
        let track = searchResults[indexPath.row]
        
        cell.title.text = track.name
        cell.artist.text = track.artist
        
        return cell;
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
