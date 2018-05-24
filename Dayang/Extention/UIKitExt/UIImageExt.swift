//
//  UIImageExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/13.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

extension UIImage {

    public class func  scaleImageFrame(image: UIImage?) -> CGRect {
        if image == nil || image?.size ==  CGSize.zero {
            return CGRect.zero
        }
        let screenSize = UIScreen.main.bounds.size
        let screenScale = screenSize.width / screenSize.height
        let imageScale = (image?.size.width)! / (image?.size.height)!
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        var width = CGFloat(0)
        var height = CGFloat(0)
        
        if imageScale > screenScale {
            width = screenSize.width
            height = width / imageScale
            y = (screenSize.height - height) / 2
        }else{
            width = screenSize.width
            height = width / imageScale
            y = 0
            //            height = screenSize.height
            //            width = height * imageScale
            //            x = (screenSize.width - width) / 2
        }
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
