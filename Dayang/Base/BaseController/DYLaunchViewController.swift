//
//  DYLaunchViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/27.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYLaunchViewController: UIViewController,CAAnimationDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //在这个C里  可以做启动页的动画效果  这里仅做一个简单的动画吧 实现步骤如下
        // 1.删除系统创建的LaunchScreen.StoryBoard 为啥要删除，因为系统创建的不支持关联 DYLaunchViewController
        // 2.在storyboard里关联本类
        // 3.coding...
        // 4.回到rootController 添加视图
        
        addAnimation()
    }
    
    private func addAnimation() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.delegate = self
        
        let rotateAnimation = CABasicAnimation()
        rotateAnimation.keyPath = "transform.rotation"
        rotateAnimation.toValue = Double.pi * 4.0
        
        let scaleAnimation = CABasicAnimation()
        scaleAnimation.keyPath = "transform.scale"
        scaleAnimation.toValue = 0
        
        let opacityAnimation = CABasicAnimation()
        opacityAnimation.keyPath = "opacity"
        opacityAnimation.toValue = 0

        
        groupAnimation.duration = 1
        let timingFunc = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        groupAnimation.timingFunction = timingFunc
        groupAnimation.animations = [rotateAnimation, scaleAnimation,opacityAnimation]
        groupAnimation.setValue("animation", forKey: "animType")
        groupAnimation.isRemovedOnCompletion = true
        groupAnimation.fillMode = kCAFillModeBoth
        view.layer.add(groupAnimation, forKey: "")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        view.isHidden = true
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
