//
//  WXXCellAnimation.swift
//  SandboxFileManager
//
//  Created by 田向阳 on 2017/8/18.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class WXXCellAnimation: NSObject {

    open class func shakeAnimation(view: UIView) {
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "transform.rotation"
        let angle = Double.pi/4/18;
        shakeAnimation.delegate = view as? CAAnimationDelegate
        shakeAnimation.values = [-angle, angle, -angle]
        shakeAnimation.repeatCount = MAXFLOAT
        view.layer.add(shakeAnimation, forKey: "shake")
    }
    
    open class func deleteAnimation(view: UIView) {
        let deleteAnimation = CAKeyframeAnimation()
        deleteAnimation.keyPath = "transform.scale"
        deleteAnimation.delegate = view as? CAAnimationDelegate
        deleteAnimation.values = [1,0]
        deleteAnimation.repeatCount = 0
        view.layer.add(deleteAnimation, forKey: "delete")
    }
    
}
