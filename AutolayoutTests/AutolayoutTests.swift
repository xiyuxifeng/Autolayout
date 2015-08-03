//
//  AutolayoutTests.swift
//  AutolayoutTests
//
//  Created by 王辉 on 15/7/25.
//  Copyright (c) 2015年 Wang.Hui. All rights reserved.
//

import UIKit
import XCTest

class AutolayoutTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    let condition = NSCondition()
    let mainCondition = NSCondition()
    let singleton: NSMutableArray = NSMutableArray()
    let threadNumbers = 1000
    var count = 0
    
    
    func testSingletonThreadSafe() {
        
        for index in 0...threadNumbers {
            NSThread.detachNewThreadSelector("startNewThread", toTarget: self, withObject: nil)
        }
        condition.broadcast()
        mainCondition.lock()
        mainCondition.wait()
        mainCondition.unlock()
        checkOnlyOne()
    }
    
    func startNewThread() {
        condition.lock()
        condition.wait()
        condition.unlock()
        let temp = AFHTTPClient.shareClient()
        count++
        singleton.addObject(temp)
        if count >= threadNumbers {
            mainCondition.signal()
        }
    }
    
    func checkOnlyOne() {
        let one = singleton[0] as AFHTTPClient
        for temp : AnyObject  in singleton {
            let newTemp = temp as AFHTTPClient
            if(newTemp === one) {
                XCTFail("singleton error!");
                break;
            }
        }
    }

}
