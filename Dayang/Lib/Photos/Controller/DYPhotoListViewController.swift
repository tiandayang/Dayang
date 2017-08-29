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

    public var selectComplete: ((_ selectArray: Array<DYPhotoModel>)->())? //选择完成的回调
    public var maxSelectCount: Int = 9 //做多选择的个数
    
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
    //MARK: LoadData
    private func loadData() {
        
        DYPhotosHelper.prepareAssetList(fetchAssets: (albumModel?.fetchAssets)!) { (listArray) in
            self.dataArray = listArray
            self.collectionView.reloadData()
        }
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
            make.edges.equalToSuperview()
        }
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

extension DYPhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        cell.photoModel = photoModel!
        
        for (index,model) in selectArray.enumerated() {
            model.selectIndex = index + 1
        }
        updateNavigationRightTitle()
        cell.cellDidClickAnimation {
            collectionView.reloadData()
        }
        
    }

}
