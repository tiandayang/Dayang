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

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("init:",self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    deinit {
        print("dealloc:",self)
    }
    
    private func initControllerFirstData() {
        
    }
    //MARK: Action
    public func didClickNavigationBarRightButton() {
        
    }
    
    /// 设置带有标题的 rightItem
    ///
    /// - Parameter title: 标题
    public func setRightButtonItemWithTitle(title: NSString) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title as String, style: .plain, target: self, action: #selector(didClickNavigationBarRightButton))
    }
}
