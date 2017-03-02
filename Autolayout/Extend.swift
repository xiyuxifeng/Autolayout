//
//  Extend.swift
//  Autolayout
//
//  Created by WangHui on 15/7/29.
//  Copyright (c) 2015年 Wang.Hui. All rights reserved.
//

import Foundation
import UIKit

let IS_IPAD             = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
let IS_IPHONE           = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
let IS_RETINA           = UIScreen.main.scale >= 2.0

let SCREEN_WIDTH        = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT       = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH   = max(SCREEN_HEIGHT, SCREEN_WIDTH)
let SCREEN_MIN_LENGTH   = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = IS_IPHONE && (SCREEN_MAX_LENGTH) < 568.0
let IS_IPHONE_5         = IS_IPHONE && (SCREEN_MAX_LENGTH) == 568.0
let IS_IPHONE_6         = IS_IPHONE && (SCREEN_MAX_LENGTH) == 667.0
let IS_IPHONE_6P        = IS_IPHONE && (SCREEN_MAX_LENGTH) == 736.0

func getImageURLString(_ imageUrl: String, width: Int, height: Int) -> String {
    
    var exactUrl = ""
    var urlArr = imageUrl.components(separatedBy: "/")
    
    for i in 0..<urlArr.count - 1  {
        if i == 2 {
            exactUrl = exactUrl + "image.kiklink.com"
        } else {
            exactUrl = exactUrl + urlArr[i]
        }
        
        exactUrl = exactUrl + "/"
    }
    
    exactUrl = exactUrl.appendingFormat("@%dw_%dh_1e_1c_1o_100Q.png", width, height)
    
    return exactUrl
}
