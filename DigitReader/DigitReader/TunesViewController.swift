//
//  TunesViewController.swift
//  DigitReader
//
//  Created by LT-145-PRANAY-PAWAR on 29/08/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TunesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tunesTableView: UITableView!
    
    let queryService = QueryService()
    var searchResults : [Track] = []
    
    let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Downloads"
        
        self.bindUI()
    }

}

extension TunesViewController {
    
    
    func bindUI() {
        
        self.searchBar.rx.text
            .orEmpty
            .filter { searchText in

                return searchText.count > 2

        }
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .map { searchText in

            var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
            urlComponents.queryItems = [URLQueryItem(name: "media", value: "music"),
                                        URLQueryItem(name: "entity", value: "song"),
                                        URLQueryItem(name: "term", value: searchText)]

            return URLRequest(url: urlComponents.url!)
        }
        .flatMapLatest { urlRequest in
            
            return URLSession.shared.rx.json(request: urlRequest)
                .catchErrorJustReturn([])
            
        }
        .map { jsonRespone -> ([Track]) in
            
            guard let json = jsonRespone as? [String: Any],
                let results = json["results"] as? [[String: Any]] else {
                    
                    return []
            }
            
            return results.compactMap(Track.init)
            
        }
        .bind(to: tunesTableView.rx.items) { tableView, row, track in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell") as! TrackTableViewCell
                        
            cell.title.text = track.name
            cell.artist.text = track.artist
            
            return cell;
            
        }.disposed(by: bag)
    }
    
}
