//
//  DYBaseViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYBaseViewController: UIViewController {

    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dy_Print("init:\(self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    deinit {
        dy_Print("dealloc:\(self)")
    }
    
    private func initControllerFirstData() {
        
    }
    //MARK: Action
    public func didClickNavigationBarRightButton() {
        
    }
    
    public func didClickNavigationBarLeftButton() {
        
    }
    
    /// 设置带有标题的 rightItem
    ///
    /// - Parameter title: 标题
    public func setRightButtonItemWithTitle(title: String) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(didClickNavigationBarRightButton))
    }
    
    /// 带有图片的 rightItem
    ///
    /// - Parameter image: 图片
    public func setRightButtonItemWithImage(image: UIImage) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didClickNavigationBarRightButton))
    }
    
    /// 设置带有标题的 leftItem
    ///
    /// - Parameter title: 标题
    public func setLeftButtonItemWithTitle(title: String) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(didClickNavigationBarLeftButton))
    }
    
    /// 带有图片的 leftItem
    ///
    /// - Parameter image: 图片
    public func setLeftButtonItemWithImage(image: UIImage) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didClickNavigationBarLeftButton))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.presentedViewController != nil && !(self.presentedViewController?.isBeingDismissed)! {
            return (self.presentedViewController?.preferredStatusBarStyle)!
        }
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        if self.presentedViewController != nil && !(self.presentedViewController?.isBeingDismissed)! {
            return (self.presentedViewController?.prefersStatusBarHidden)!
        }
        return false
    }
}
