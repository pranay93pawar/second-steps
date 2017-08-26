//
//  SegmentViewController.swift
//  DigitReader
//
//  Created by LT-145-PRANAY-PAWAR on 26/08/17.
//  Copyright © 2017 Pranay Suresh Pawar. All rights reserved.
//

import UIKit

class SegmentViewController: UIViewController {

    @IBOutlet weak var segmentCotrol: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    weak var currentViewController:UIViewController?
    
    override func viewDidLoad() {
        
        
        self.title = "Digit"
        
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DRTableViewController")
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubView(subView: (self.currentViewController?.view)!, toView: self.containerView)
        
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentCotrol.selectedSegmentIndex {
            
        case 0:
            
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "DRTableViewController")
            
            newViewController?.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
            
        case 1:
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "DRCollectionViewController")
            
            newViewController?.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        default:
            break
        }
        
    }

    
    func addSubView(subView:UIView,toView parentView:UIView) {
        
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String:AnyObject]()
        viewBindingsDict["subView"] = subView
        
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        
        
    }
    
    func cycleFromViewController(oldViewController:UIViewController,toViewController newViewController: UIViewController) {
        
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubView(subView: newViewController.view, toView: self.containerView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations:{
            
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            
            },completion:{ finished in
                
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                oldViewController.didMove(toParentViewController: self)
        
        })
        
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
