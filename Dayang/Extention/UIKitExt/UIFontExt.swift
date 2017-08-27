//
//  UIFontExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    public class func dy_systemFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size + self.dy_fontScaleSize())
    }
    
    public class func dy_boldSystemFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size + self.dy_fontScaleSize())
    }
    
    
    private class func dy_fontScaleSize() -> CGFloat {
        if WINDOW_HEIGHT <= 568 {
            return -1
        }else if WINDOW_HEIGHT == 736{
            return 1
        }
        return 0
    }
    
}
