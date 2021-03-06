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
    var homeModel: DYHomeModel? //
    
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
        DYHomeModel.getHomePageRequest { (error, model) -> (Void) in
            if error.code == errorCode.success.rawValue || error.code == errorCode.cache.rawValue {
                self.homeModel = model
                let bannerView = self.tableView.tableHeaderView as! DYBannerView
                bannerView.bannerArray = self.homeModel?.banner
                self.tableView.reloadData()
            }else{
                DYHUDHelper.showHUD(inView: self.view, title: error.localizedDescription)
            }
            self.tableView.mj_header.endRefreshing()
        }
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
    
    @objc private func footerRefresh() {
        tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    
    @objc private func headerRefresh() {
        loadData()
    }
    
    //MARK: AddNotificatoin
    private func registNotification() {
        
    }
    //MARK: CreateUI
    private func createUI() {
        let bannerView = DYBannerView(frame:CGRect.init(x: 0, y: 0, width: WINDOW_WIDTH, height: 200))
//        let bannerArray = DYBannerModel.getBannerArray()
//        bannerView.bannerArray = bannerArray
        self.tableView.tableHeaderView = bannerView
        
        bannerView.bannerTapBlock = { [weak self] (bannerModel) in
           
            let photoPreviewVC = DYPhotoPreviewController()
            var array = [DYPhotoPreviewModel]()
            for model in bannerView.bannerArray! {
                let photoModel = DYPhotoPreviewModel()
                photoModel.imageURL = model.icon
                if(model.icon?.contains("mp4")) ?? false{
                    photoModel.isVideo = true
                    photoModel.videoURL = model.icon
                }
                array.append(photoModel)
            }
            photoPreviewVC.dataArray = array
            photoPreviewVC.selectIndex = bannerView.bannerArray?.index(of: bannerModel) ?? 0
            photoPreviewVC.thumbTapView = (bannerView.collectionView.visibleCells.first as! DYBannerCollectionCell).imageView
            photoPreviewVC.tapSuperView = bannerView.collectionView
            self?.present(photoPreviewVC, animated: true, completion: nil)
        }
        
        tableView.dy_addHeaderFooterRefresh(target: self, headerSelector: #selector(headerRefresh), footerSelector: #selector(footerRefresh))
    }
    //MARK: Helper
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
