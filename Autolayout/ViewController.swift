//
//  ViewController.swift
//  Autolayout
//
//  Created by 王辉 on 15/7/25.
//  Copyright (c) 2015年 Wang.Hui. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var homeSearchBar: HomeSearchBarView = (UINib(nibName: "HomeSearchBarView", bundle: nil).instantiateWithOwner(self, options: nil).first) as! HomeSearchBarView
        
        self.navigationItem.titleView = homeSearchBar
        
        homeSearchBar.searchBtn.addTarget(self, action: "gotoSearchVC", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeSecondCell")
        
        if IS_IPHONE_6P {
            ScrollViewHeight.constant = 621.0 / 3.0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row % 2 == 0   {
            var cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as! UITableViewCell
//            cell.textLabel?.text = "sss"
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("homeSecondCell", forIndexPath: indexPath) as! UITableViewCell
            //            cell.textLabel?.text = "sss"
            return cell
        }
        
    }
    
    
    func gotoSearchVC() {
        println("Test: \(self.ScrollViewHeight!.description)")
    }
    
    func gotoMapVC() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

