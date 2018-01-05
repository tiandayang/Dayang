//
//  DYRootViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYRootViewController: UIViewController {
    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        createUI()
    }
    
    private func initControllerFirstData() {
     view.backgroundColor = .white
    }
    
    private func createUI() {
        //判断是否安装过APP~
        if UserDefaults.isNotFirstInstall() {
            gotoHome()
        } else {
            gotoGuid()
        }
        
        // 添加启动页动画
        addLaunch()
    }

    private func addLaunch() {
        let launchVC = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreen")
        self.addChildViewController(launchVC)
        view.addSubview(launchVC.view)
        launchVC.view.frame = view.bounds
    }
    
    private func gotoHome() {
        let homeVC = DYHomeViewController()
        let nav = DYBaseNavigationController.init(rootViewController: homeVC)
        self.addChildViewController(nav)
        self.view.addSubview(nav.view)
        nav.view.frame = view.bounds
    }
    
    private func gotoGuid() {
        let guideVC = DYGuideViewController()
        self.addChildViewController(guideVC)
        guideVC.view.frame = view.bounds
        view.addSubview(guideVC.view)
        guideVC.nextBlock = {[weak self] () in
            self?.gotoHome()
        }
    }
    //MARK: 统一管理 状态栏 
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return lastChildController()
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return lastChildController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return lastChildController()?.preferredStatusBarStyle ?? .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return lastChildController()?.prefersStatusBarHidden ?? false
    }
    
    private func lastChildController() -> UIViewController? {
        if self.presentedViewController != nil && !(self.presentedViewController?.isBeingDismissed)! {
            //为了迎合 present 出来的VC 如果需要改变状态栏的话  、、 相应的被present的Controller 需要增加一个判断  isBeingDismissed 如果是正在被dismiss 则返回根视图的状态栏状态
            return self.presentedViewController
        }
        return self.childViewControllers.last
    }
}
