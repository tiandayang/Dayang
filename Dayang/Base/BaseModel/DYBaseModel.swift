//
//  DYBaseModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import RealmSwift

let DYRealm = try! Realm()

class DYBaseModel: Object,NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
       return self
    }
    
}
