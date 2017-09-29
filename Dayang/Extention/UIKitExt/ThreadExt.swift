//
//  ThreadExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
extension DispatchQueue {

    func dy_safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}

