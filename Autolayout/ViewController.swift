//
//  ViewController.swift
//  Autolayout
//
//  Created by 王辉 on 15/7/25.
//  Copyright (c) 2015年 Wang.Hui. All rights reserved.
//

import UIKit

typealias BannerCallBackBlock = (_ result: AnyObject?, _ error: NSError?) -> Void

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let homeSearchBar: HomeSearchBarView = (UINib(nibName: "HomeSearchBarView", bundle: nil).instantiate(withOwner: self, options: nil).first) as! HomeSearchBarView
        
        self.navigationItem.titleView = homeSearchBar
        
        homeSearchBar.searchBtn.addTarget(self, action: #selector(ViewController.gotoSearchVC), for: UIControlEvents.touchUpInside)
        
        homeSearchBar.mapBtn.addTarget(self, action: #selector(ViewController.gotoMapVC), for: UIControlEvents.touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeSecondCell")
        
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
    
    func initCycleScrollView(_ dataArr: NSArray) {
        
        let scale = SCREEN_WIDTH / 320.0
        tableHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 165.0 * scale)
        
        let headerView = CycleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 165.0 * scale), animationDuration: 2.0, style: CycleStylePage, andImageCount: dataArr.count)
        
        var imageArr = [UIImageView]()
 
        for dict in dataArr {
            
            let imageUrl = ((dict as! NSDictionary).value(forKey: "images") as AnyObject).firstObject
            let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 165.0 * scale))
            
            if (imageUrl != nil) && !(imageUrl is NSNull){
                
                imageView.setImageWith(URL(string: imageUrl as! String), placeholderImage: UIImage(named: "俱乐部课程穿插的图片的患冲图片"))
            }
            
            imageArr.append(imageView)
            
            print(imageView)
        }
        
        headerView?.fetchContentViewAtIndex = {(pageIndex: Int) -> UIView in
            return imageArr[pageIndex]
        }
        
        headerView?.totalPagesCount = { dataArr.count }
        
        headerView?.tapActionBlock = {(pageIndex: Int) in
            let dict = dataArr[pageIndex] as! NSDictionary
            let type = dict.value(forKey: "type") as! Int
            var toid = dict.value(forKey: "toid") as! Int
            
            if type == 1 {
                
                print("type 1 click")
                
            } else {
                
                print("other type click")
            }
        }
        
        tableView.tableHeaderView = headerView
        
    }
    
    func getBannerDataFromServer(_ callBackBlock: BannerCallBackBlock?) {
        
        
        /*AFHTTPClient.shareClient().get("nalan/bulletin.json", parameters: nil, success: {(task:  URLSessionDataTask!, responseObject: AnyObject!) -> Void in
            
            if let callBack = callBackBlock {
                
                if !(responseObject.value(forKey: "data") is NSNull) {
                    
                    callBack(result: responseObject.value(forKey: "data"), error: nil)
                    
                } else {
                    print("get banner error")
                }
                
            }}, failure: { (task: URLSessionDataTask!, error: NSError!) -> Void in
                
                if let callBack = callBackBlock {
                    callBack(result: NSArray(), error: error)
                }
            }
        )*/
    }
    
    
    
    func gotoSearchVC() {

    }
    
    func gotoMapVC() {
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_IPHONE_6P ? 200.0 : 165.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeSecondCell", for: indexPath) as! HomeTableViewCell
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

