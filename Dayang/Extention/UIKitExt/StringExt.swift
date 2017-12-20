//
//  StringExt.swift
//  Dayang 摘自项目组: TCZKit
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    /// 字符长度
    public var length: Int {
        return self.characters.count
    }
    
    /// 检查是否空白
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    ///去空格换行
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// string字数
    public var countofWords: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+", options: NSRegularExpression.Options())
        return regex?.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.length)) ?? 0
    }
    
    /// 去空格换行 返回新的字符串
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    ///  json 字符转字典
    public func toDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    /// String to Int
    public func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }
    
    /// String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// String to Bool
    public func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    ///  String to NSString
    public var toNSString: NSString { return self as NSString }
    
    ///字符串高度
    public func height(_ width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?) -> CGFloat {
        var attrib: [String: AnyObject] = [NSFontAttributeName: font]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attrib.updateValue(paragraphStyle, forKey: NSParagraphStyleAttributeName)
        }
        let size = CGSize(width: width, height: CGFloat(Double.greatestFiniteMagnitude))
        return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attrib, context: nil).height)
    }
    
    /// MD5
    ///
    /// - Returns: MD5
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
    
    
    /// 是否为正确的是手机号
    ///
    /// - Parameter phone: 手机号
    /// - Returns: 是否正确
    static func isValidPhone (phone:String)->(Bool){
        
        let str = "^[1-9][0-9]{4,11}$"
        
        let mobilePredicate = NSPredicate(format: "SELF MATCHES %@",str)
        
        return mobilePredicate.evaluate(with: phone)
    }
    
    /// 千分符 1，000格式
    ///
    /// - Parameter str: 数字
    /// - Returns: 1，000
    static func calcuteSymbolLocation(str: String) -> String {
        
        var resultStr = str
        
        let symbolStr = "."
        
        let subRange = (resultStr as NSString).range(of: symbolStr)
        
        
        if subRange.location == 4  || subRange.location == 5 {
            
            resultStr.insert(",", at: str.index(resultStr.startIndex, offsetBy: 1))
        }
        
        return resultStr
        
    }
    
    /// 清除字符串小数点末尾的0
    func cleanDecimalPointZear() -> String {
        let newStr = self as NSString
        var s = NSString()
        
        var offset = newStr.length - 1
        while offset > 0 {
            s = newStr.substring(with: NSMakeRange(offset, 1)) as NSString
            if s.isEqual(to: "0") || s.isEqual(to: ".") {
                offset -= 1
            } else {
                break
            }
        }
        return newStr.substring(to: offset + 1)
    }
    
    public func isNetUrl() ->Bool {
        if self.length > 0 {
            return self.hasPrefix("http://") || self.hasPrefix("https://")
        }
        return false
    }
}
