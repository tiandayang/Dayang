//
//  DictionaryExt.swift
//  Dayang 摘自项目组: TCZKit
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public func toJsonString() -> String {
        do {
            let stringData = try JSONSerialization.data(withJSONObject: self as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let string = String(data: stringData, encoding: String.Encoding.utf8){
                return string
            }
        } catch _ {
            return ""
        }
        return ""
    }
}
