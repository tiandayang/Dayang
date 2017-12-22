//
//  WXXFileListViewController.swift
//  SandboxFileManager
//
//  Created by 田向阳 on 2017/8/17.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class WXXFileListViewController: UIViewController {

    open var path: String = WXXFileServer.rootPath()
    private var dataArray: [WXXFileListModel]?
    private var isEdit: Bool = false

    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        createUI()
        loadData()
        registNotification()
    }
    
    deinit {
        dy_Print("dealloc:\(self)")
    }
    
    //MARK: LoadData
    private func loadData() {
        DispatchQueue.global().async {
            self.dataArray = WXXFileServer.getSubFolder(path: self.path)
            DispatchQueue.main.async {
                self.collectionView.fileListArray = self.dataArray;
            }
        }
    }
    
    private func initControllerFirstData() {
//        if (navigationController?.viewControllers.count)! <= 1 {
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(navigationItemLeftClick))
//        }else{
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(navigationItemRightClick))
//        }
    }
    //MARK: Action
    @objc private func navigationItemLeftClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func navigationItemRightClick() {
        isEdit = !isEdit
        if isEdit {
            self.collectionView.startDeleteAnimation()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(navigationItemRightClick))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(navigationItemRightClick))
            self.collectionView.endShakeAnimation()
        }
        
    }
    
    //MARK: AddNotificatoin
    private func registNotification() {
        self.collectionView.didSelectRowBlock = {[weak self] (model: WXXFileListModel) in
            if model.fileType == .folder {
                let VC = WXXFileListViewController()
                VC.path = model.filePath
                VC.title = model.fileName
                self?.navigationController?.pushViewController(VC, animated: true)
            }else{
                let VC = WXXFilePreViewViewController()
                var array = [WXXFileListModel]()
                for fileModel in (self?.dataArray)! {
                    if fileModel.fileType != .folder {
                        array.append(fileModel)
                    }
                }
                if let index = array.index(of: model) {
                    VC.currentIndex = index
                }
                VC.fileArray = array
                self?.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    @objc private func appDidEnterBackground() {
        if isEdit {
            navigationItemRightClick()
        }
    }
    
    //MARK: CreateUI
    private func createUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    lazy var collectionView: WXXFileListCollectionView = {
        let collectionView = WXXFileListCollectionView()
        
        return collectionView
    }()
    //MARK: Helper

}
