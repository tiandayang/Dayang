//
//  UserDefaultExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let kIsFirstInstallKey = "DaYang.isFirst"

extension UserDefaults {
    
    class func isNotFirstInstall() -> Bool {
        return UserDefaults.standard.bool(forKey: kIsFirstInstallKey)
    }
    
    class func saveIsNotFirstInstall(isFirst: Bool) {
        UserDefaults.standard.set(isFirst, forKey: kIsFirstInstallKey)
        UserDefaults.standard.synchronize()
    }
}
