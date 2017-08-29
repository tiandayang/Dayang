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

    var dataArray = [DYPhotoModel]()
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
        
    }
    //MARK: Action
    
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

}
