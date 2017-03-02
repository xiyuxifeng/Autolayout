//
//  ViewController.swift
//  Autolayout
//
//  Created by 王辉 on 15/7/25.
//  Copyright (c) 2015年 Wang.Hui. All rights reserved.
//

import UIKit

typealias BannerCallBackBlock = (result: AnyObject!, error: NSError?) -> Void

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let homeSearchBar: HomeSearchBarView = (UINib(nibName: "HomeSearchBarView", bundle: nil).instantiateWithOwner(self, options: nil).first) as! HomeSearchBarView
        
        self.navigationItem.titleView = homeSearchBar
        
        homeSearchBar.searchBtn.addTarget(self, action: "gotoSearchVC", forControlEvents: UIControlEvents.TouchUpInside)
        
        homeSearchBar.mapBtn.addTarget(self, action: "gotoMapVC", forControlEvents: UIControlEvents.TouchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeSecondCell")
        
        self.initHeaderView()


    }
    
    func initHeaderView() {
        self.getBannerDataFromServer { (result, error) -> Void in
            if error == nil {
                let dataArr = result as! NSArray
                if dataArr.count > 0 {
                    self.initCycleScrollView(dataArr)
                }
            }
        }
    }
    
    func initCycleScrollView(dataArr: NSArray) {
        
        let scale = SCREEN_WIDTH / 320.0
        tableHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 165.0 * scale)
        
        let headerView = CycleScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 165.0 * scale), animationDuration: 2.0, style: CycleStylePage, andImageCount: dataArr.count)
        
        var imageArr = [UIImageView]()
 
        for dict in dataArr {
            
            let imageUrl = (dict as! NSDictionary).valueForKey("images")?.firstObject
            let imageView = UIImageView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 165.0 * scale))
            
            if (imageUrl != nil) && !(imageUrl is NSNull){
                
                imageView.setImageWithURL(NSURL(string: imageUrl as! String), placeholderImage: UIImage(named: "俱乐部课程穿插的图片的患冲图片"))
            }
            
            imageArr.append(imageView)
            
            print(imageView)
        }
        
        headerView.fetchContentViewAtIndex = {(pageIndex: Int) -> UIView in
            return imageArr[pageIndex]
        }
        
        headerView.totalPagesCount = { dataArr.count }
        
        headerView.TapActionBlock = {(pageIndex: Int) in
            let dict = dataArr[pageIndex] as! NSDictionary
            let type = dict.valueForKey("type") as! Int
            var toid = dict.valueForKey("toid") as! Int
            
            if type == 1 {
                
                print("type 1 click")
                
            } else {
                
                print("other type click")
            }
        }
        
        tableView.tableHeaderView = headerView
        
    }
    
    func getBannerDataFromServer(callBackBlock: BannerCallBackBlock?) {
        
        
        AFHTTPClient.shareClient().GET("nalan/bulletin.json", parameters: nil, success: {(task:  NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
            
            if let callBack = callBackBlock {
                
                if !(responseObject.valueForKey("data") is NSNull) {
                    
                    callBack(result: responseObject.valueForKey("data"), error: nil)
                    
                } else {
                    print("get banner error")
                }
                
            }}, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                
                if let callBack = callBackBlock {
                    callBack(result: NSArray(), error: error)
                }
            }
        )
    }
    
    
    
    func gotoSearchVC() {

    }
    
    func gotoMapVC() {
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return IS_IPHONE_6P ? 200.0 : 165.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("homeSecondCell", forIndexPath: indexPath) as! HomeTableViewCell
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

