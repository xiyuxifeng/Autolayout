//
//  AFHTTPClient.swift
//  Autolayout
//
//  Created by WangHui on 15/8/3.
//  Copyright (c) 2015年 Wang.Hui. All rights reserved.
//

import UIKit

let BaseURL = "http://dev.kiklink.com:8086/v1/"

class AFHTTPClient: AFHTTPSessionManager {
    
    private static var __once: () = { () -> Void in
            
            let baseURL = URL(string: BaseURL)
            let sessionConfig = URLSessionConfiguration.default
            
            // 设置缓存大小
            let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 5 * 1024 * 1024, diskPath: nil)
            sessionConfig.urlCache = cache
            
            
//            Static.shareClient = AFHTTPClient(baseURL: baseURL, sessionConfiguration: sessionConfig)
//            Static.shareClient?.responseSerializer = AFJSONResponseSerializer()
//            Static.shareClient?.requestSerializer = AFHTTPRequestSerializer()
//            Static.shareClient?.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
        }()
    
    class func shareClient() -> AFHTTPClient {
        
        struct Static {
            static var shareClient: AFHTTPClient? = nil
            static var onceToken: Int = 0
        }
        
        _ = AFHTTPClient.__once
        
        return Static.shareClient!
    }
}


let _shareInstance = AFHTTPClient2()

class AFHTTPClient2: AFHTTPSessionManager {
    
    class var shareInstance: AFHTTPClient2 {
        return _shareInstance
    }
    
    init() {
        let baseURL = URL(string: BaseURL)
        let sessionConfig = URLSessionConfiguration.default
        
        // 设置缓存大小
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 5 * 1024 * 1024, diskPath: nil)
        sessionConfig.urlCache = cache
        
        super.init(baseURL: baseURL, sessionConfiguration: sessionConfig)
        
        self.responseSerializer = AFJSONResponseSerializer()
        self.requestSerializer = AFHTTPRequestSerializer()
        self.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class AFHTTPClient3: AFHTTPSessionManager {
    
    class var shareInstance: AFHTTPClient3 {
        struct Static {
            static let instance : AFHTTPClient3 = AFHTTPClient3()
        }
        return Static.instance
    }
    
    init() {
        let baseURL = URL(string: BaseURL)
        let sessionConfig = URLSessionConfiguration.default
        
        // 设置缓存大小
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 5 * 1024 * 1024, diskPath: nil)
        sessionConfig.urlCache = cache
        
        super.init(baseURL: baseURL, sessionConfiguration: sessionConfig)
        
        self.responseSerializer = AFJSONResponseSerializer()
        self.requestSerializer = AFHTTPRequestSerializer()
        self.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






