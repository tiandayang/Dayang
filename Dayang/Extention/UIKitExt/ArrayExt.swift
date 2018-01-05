//
//  ArrayExt.swift
//  Dayang 摘自项目组: TCZKit
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import Foundation

extension Array {
    
    public func toJsonString() -> String {
        
        var result:String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    public func dy_objectAtIndex(index: Int) -> Element? {
        
        if index < self.count {
            return self[index]
        }
        return nil
    }
    
}
