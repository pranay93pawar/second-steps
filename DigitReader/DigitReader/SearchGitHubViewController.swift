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
    
    var repoItems = BehaviorRelay<[Repo]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search Github"
        
        self.bindUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getDefaultItems()
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
        .subscribe(onNext: { jsonResponse in
            
            if let json = jsonResponse as? [String:Any],
                let items = json["items"] as? [[String:Any]] {
                
                self.repoItems.accept(items.compactMap(Repo.init))
                
            }else {
                self.repoItems.accept([])
            }
            
            
            
        }).disposed(by: bag)
        
        
        self.searchBar.rx
            .cancelButtonClicked
            .subscribe(onNext: { [unowned self] in
        
                self.getDefaultItems()
            })
            .disposed(by: bag)
        
        self.repoItems
            .asObservable()
            .bind(to: tableview.rx.items) { tableview, row , repo in
                
                print("row: \(row) repo: \(repo)")
                let cell = tableview.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = repo.name
                cell.detailTextLabel?.text = repo.language
                return cell
        }
        .disposed(by: bag)
    }
    
    func getDefaultItems() {
        
        let uRLRequest = URLRequest(url: URL(string: "https://api.github.com/repositories")!)
        
        URLSession.shared.rx.json(request: uRLRequest)
            .catchErrorJustReturn([])
            .asObservable()
            .subscribe(onNext: { jsonResponse in
                
                if let items = jsonResponse as? [[String:Any]] {
                    print(items)
                    self.repoItems.accept(items.compactMap(Repo.init))
                    
                }else {
                    self.repoItems.accept([])
                }
                
                print(self.repoItems.value)
            })
            .disposed(by: bag)
        
    }
}
