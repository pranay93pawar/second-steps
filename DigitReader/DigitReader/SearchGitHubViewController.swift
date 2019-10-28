//
//  SearchGitHubViewController.swift
//  DigitReader
//
//  Created by Mac-145-Pranay-Pawar on 28/10/19.
//  Copyright © 2019 Pranay Suresh Pawar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchGitHubViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search Github"
        
        self.bindUI()
    }

}

extension SearchGitHubViewController {
    
    func bindUI() {
        
        searchBar.rx.text
            .orEmpty
            .filter { serachQuery in
                return serachQuery.count > 2
        }
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .map{ serachQuery in
            var url = URLComponents(string: "https://api.github.com/search/repositories")
            url?.queryItems = [URLQueryItem(name: "q", value: serachQuery)]
            
            return URLRequest(url: url!.url!)
            
        }
        .flatMapLatest { urlRequest in
            
            return URLSession.shared.rx.json(request: urlRequest)
                .catchErrorJustReturn([])
            
            }
        .map { jsonResponse -> [Repo] in
            
            guard let json = jsonResponse as? [String:Any],
                let items = json["items"] as? [[String:Any]] else {
                    return []
            }
         
            return items.compactMap(Repo.init)
            
        }
        .bind(to: tableview.rx.items) { tableview, row , repo in
            
            print("row: \(row) repo: \(repo)")
            let cell = tableview.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = repo.name
            cell.detailTextLabel?.text = repo.language
            return cell
        }
    }
    
}
