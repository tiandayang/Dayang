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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
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
        model.icon = "http://a2.qpic.cn/psb?/V14WN2Fi0BvLd1/sNnGniEg*YFEzlF*7.Z*Qfz0FdlpPF5.U0aLP7wBL3o!/b/dAuM4nRqJgAA&bo=VgHcAFYB3AAFByQ!&rf=viewer_4";
        let array = [model,model,model]
        bannerView.bannerArray = array
        self.tableView.tableHeaderView = bannerView
        
        bannerView.bannerTapBlock = { [weak self] (bannerModel) in
           
            let photoPreviewVC = DYPhotoPreviewController()
            var array = [DYPhotoPreviewModel]()
            for model in bannerView.bannerArray! {
                let photoModel = DYPhotoPreviewModel()
                photoModel.imageURL = model.icon
                array.append(photoModel)
            }
            photoPreviewVC.dataArray = array
            photoPreviewVC.thumbTapView = (bannerView.collectionView.visibleCells.first as! DYBannerCollectionCell).imageView
            photoPreviewVC.tapSuperView = bannerView.collectionView
            self?.present(photoPreviewVC, animated: true, completion: nil)
        }
    }
    //MARK: Helper
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
