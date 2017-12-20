//
//  DYLaunchViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/27.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYLaunchViewController: UIViewController,CAAnimationDelegate {

    lazy var imageView: UIImageView = {
        let imageView = self.view.subviews.first as! UIImageView
        return imageView
    }()
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
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseInOut, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.imageView.alpha = 0
        }) { (finish) in
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
}
