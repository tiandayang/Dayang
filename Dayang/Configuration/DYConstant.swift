//
//  DYConstant.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

//屏幕宽高
public let WINDOW_WIDTH = UIScreen.main.bounds.size.width
public let WINDOW_HEIGHT = UIScreen.main.bounds.size.height

//屏幕宽高比
public let WINDOW_WIDTH_SCALE = UIScreen.main.bounds.size.width / 375
public let WINDOW_HEIGHT_SCALE = UIScreen.main.bounds.size.height / 667

//按当前屏幕宽高比适配后的宽度和高度
public func SCALE_WIDTH(width:CGFloat) -> CGFloat {
    return UIScreen.main.bounds.size.width / 375 * width
}
public func SCALE_HEIGHT(height:CGFloat) -> CGFloat {
    return UIScreen.main.bounds.size.height / 667 * height
}

public func dy_safeAsync(_ block: @escaping ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}

