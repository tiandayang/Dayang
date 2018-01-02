//
//  UIDeviceExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/27.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

extension UIDevice {
    
    class func dy_deviceAlias() -> String {
        let device = UIDevice()
        return device.name
    }
}
