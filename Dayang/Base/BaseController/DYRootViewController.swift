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
}
