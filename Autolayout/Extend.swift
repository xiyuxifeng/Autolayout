//
//  Extend.swift
//  Autolayout
//
//  Created by WangHui on 15/7/29.
//  Copyright (c) 2015年 Wang.Hui. All rights reserved.
//

import Foundation
import UIKit

let IS_IPAD             = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad
let IS_IPHONE           = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone
let IS_RETINA           = UIScreen.mainScreen().scale >= 2.0

let SCREEN_WIDTH        = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT       = UIScreen.mainScreen().bounds.size.height
let SCREEN_MAX_LENGTH   = max(SCREEN_HEIGHT, SCREEN_WIDTH)
let SCREEN_MIN_LENGTH   = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = IS_IPHONE && (SCREEN_MAX_LENGTH) < 568.0
let IS_IPHONE_5         = IS_IPHONE && (SCREEN_MAX_LENGTH) == 568.0
let IS_IPHONE_6         = IS_IPHONE && (SCREEN_MAX_LENGTH) == 667.0
let IS_IPHONE_6P        = IS_IPHONE && (SCREEN_MAX_LENGTH) == 736.0
