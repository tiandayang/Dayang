//
//  DYPhotoListViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let  kItemsOfRow = 3
private let  kItemsSpace = 4.0
private let  ITEMWIDTH = 2.0 * (WINDOW_WIDTH - 4*4)/3.0

class DYPhotoListViewController: DYBaseViewController {

    open var selectComplete: dySelectImagesComplete?
    open var maxSelectCount: Int = 9 //做多选择的个数
    fileprivate var dataArray = [DYPhotoModel]()   // 数据源
    fileprivate var selectArray = [DYPhotoModel]() // 已选择的数组
    
    weak var albumModel: DYAlbumModel?
    
    //MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerFirstData()
        createUI()
        loadData()
    }
    
    deinit {

    }
    
    //MARK: LoadData
    private func loadData() {

        self.dataArray = (albumModel?.assetList)!
        
       self.selectArray = self.dataArray.filter { (photoModel) -> Bool in
            return photoModel.isSelect
        }
        updateNavigationRightTitle()
        collectionView.reloadData()
    }
    
    private func initControllerFirstData() {
        self.setRightButtonItemWithTitle(title: "取消")
        
    }
    //MARK: Action
    
    override func didClickNavigationBarRightButton() {
        if selectArray.count>0  && self.selectComplete != nil {
            self.selectComplete!(selectArray)
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    fileprivate func updateNavigationRightTitle() {
        if selectArray.count > 0 {
            self.setRightButtonItemWithTitle(title: "确定(\(selectArray.count))")
        }else{
            self.setRightButtonItemWithTitle(title: "取消")
        }
    }
    //MARK: AddNotificatoin
    private func registNotification() {
        
    }
    //MARK: CreateUI
    private func createUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
        }
        
//        let menuView = DYPhotosMenuView()
//        view.addSubview(menuView)
//        menuView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(40)
//        }
        
//        menuView.button.tappedBlock {[weak self] (button) in
//            if (self?.selectArray.count)! > 0 {
//                var preViewArray = [DYPhotoPreviewModel]()
//                for model in (self?.selectArray)! {
//                    let preViewModel = DYPhotoPreviewModel()
//                    preViewModel.isVideo = model.isVideo
//                    preViewModel.thumbImage = model.thumImage
//                    preViewModel.asset = model.asset
//                    preViewArray.append(preViewModel)
//                }
//
//                let photoPreviewVC = DYPhotoPreviewController()
//                photoPreviewVC.tapSuperView = self?.collectionView
//                photoPreviewVC.dataArray = preViewArray
//                photoPreviewVC.delegate = self
//                let model = self?.selectArray.first
//                let index = self?.dataArray.index(of: model!)
//                let indexPath = IndexPath.init(item: index!, section: 0)
//                if let cell = self?.collectionView.cellForItem(at: indexPath) {
//                    photoPreviewVC.thumbTapView = (cell as! DYPhotoListCollectionCell).corverImage
//                }
//                self?.present(photoPreviewVC, animated: true, completion: nil)
//            }
//        }
    }
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = CGFloat(kItemsSpace);
        layout.minimumInteritemSpacing = CGFloat(kItemsSpace);
        layout.itemSize = CGSize(width: ITEMWIDTH/2.0, height: ITEMWIDTH/2.0)
        layout.sectionInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(kItemsSpace), bottom: CGFloat(kItemsSpace), right: CGFloat(kItemsSpace))
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(DYPhotoListCollectionCell.self, forCellWithReuseIdentifier: "DYPhotoListCollectionCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
}

extension DYPhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, DYPhotoPreviewControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DYPhotoListCollectionCell", for: indexPath) as! DYPhotoListCollectionCell
        if let model = dataArray.dy_objectAtIndex(index: indexPath.item) {
            cell.photoModel = model
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoModel = dataArray.dy_objectAtIndex(index: indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath) as! DYPhotoListCollectionCell
      
        if !(photoModel?.isSelect)! {
            if selectArray.count >= self.maxSelectCount {
                DYAlertViewHelper.showAlert(title: "最多只能选择\(self.maxSelectCount)张图片", controller: self, complete: nil)
                return
            }
            photoModel?.isSelect = true
            selectArray.append(photoModel!)
            photoModel?.selectIndex = selectArray.count
        }else{
            photoModel?.isSelect = false
            if let index = selectArray.index(of: photoModel!) {
                selectArray.remove(at: index)
            }
        }
        for (index,model) in selectArray.enumerated() {
            model.selectIndex = index + 1
        }
        cell.photoModel = photoModel!
        updateNavigationRightTitle()
        cell.cellDidClickAnimation {
            collectionView.reloadData()
        }
        
    }

    func dyPhotoDismissTargetView(indexPath: IndexPath) -> UIImageView? {
        if let cell = collectionView.cellForItem(at: indexPath) {
            return (cell as! DYPhotoListCollectionCell).corverImage
        }
        return nil
    }
}
