//
//  PostViewController.swift
//  DigitReader
//
//  Created by Pranay Suresh Pawar on 20/06/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var webView: UIWebView!
    
    var showLink:String = String()
    var itemTitle: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = itemTitle
        
        let url:URL = URL(string: showLink)!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
        
        
        /*activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        webView.scrollView.contentInset = UIEdgeInsets.zero

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

}
