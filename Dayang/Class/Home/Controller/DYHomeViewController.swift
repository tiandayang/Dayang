//
//  DYHomeViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYHomeViewController: DYBaseTableViewController {
    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        createUI()
        loadData()
        registNotification()
    }
    //MARK: LoadData
    private func loadData() {
        
    }
    
    private func initControllerFirstData() {
        self.title = "首页"
        setLeftButtonItemWithImage(image: UIImage(named: "personalCenter")!)
        
    }
    //MARK: Action
    override func didClickNavigationBarLeftButton() {
        let personVC = DYPersonalViewController()
        self.navigationController?.pushViewController(personVC, animated: true)
    }
    //MARK: AddNotificatoin
    private func registNotification() {
        
    }
    //MARK: CreateUI
    private func createUI() {
        let bannerView = DYBannerView(frame:CGRect.init(x: 0, y: 0, width: WINDOW_WIDTH, height: 200))
        let model = DYBannerModel()
        model.icon = "https://ss0.baidu.com/73F1bjeh1BF3odCf/it/u=979572852,2610260350&fm=85&s=A73013885A64788CC09C58C10300B0B4";
        let array = [model,model,model]
        bannerView.bannerArray = array
        self.tableView.tableHeaderView = bannerView
    }
    //MARK: Helper
}
