//
//  DYBaseModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import HandyJSON

let DYRealm = try! Realm()

class DYBaseModel: Object,NSCopying,HandyJSON {
    
    func copy(with zone: NSZone? = nil) -> Any {
       return self
    }
    required public init() {super.init()}
    
    required  init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required  init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
}
