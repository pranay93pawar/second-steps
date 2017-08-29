//
//  TunesViewController.swift
//  DigitReader
//
//  Created by LT-145-PRANAY-PAWAR on 29/08/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit

class TunesViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
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
            print("Hello search")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
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
