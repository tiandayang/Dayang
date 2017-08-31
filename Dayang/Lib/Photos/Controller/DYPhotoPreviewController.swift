//
//  DYPhotoPreviewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYPhotoPreviewController: DYBaseViewController {

    public var dataArray: Array<DYPhotoPreviewModel>?{
        didSet{
            loadData()
        }
    }
    
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
        collectionView.reloadData()
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
        let layout = DYPhotoPreViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 30
        layout.itemSize = CGSize(width: WINDOW_WIDTH, height: WINDOW_HEIGHT)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(DYPhotoPreViewImageCell.self, forCellWithReuseIdentifier: "DYPhotoPreViewImageCell")
        collectionView.register(DYPhotoPreviewVideoCell.self, forCellWithReuseIdentifier: "DYPhotoPreviewVideoCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        return collectionView
    }()

}

extension DYPhotoPreviewController: UICollectionViewDelegate, UICollectionViewDataSource, DYPhotoPreviewCellDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArray?[indexPath.item]
        if !(model?.isVideo)! {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DYPhotoPreViewImageCell", for: indexPath) as! DYPhotoPreViewImageCell
            imageCell.photoModel = model
            imageCell.delegate = self
            return imageCell
        }else{
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DYPhotoPreviewVideoCell", for: indexPath) as! DYPhotoPreviewVideoCell
            videoCell.photoModel = model
            videoCell.delegate = self
            return videoCell;
        }
    }
    
    func dYPhotoPreviewCellSingleTap(index: Int) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dYPhotoPreviewCellLongPress(photoModel: DYPhotoPreviewModel?) {
        
        if photoModel == nil {
            return
        }
        DYActionSheetHelper.showActionSheet(title: nil, items: ["保存到相册"], cancelTitle: "取消", controller: self) { (index) in
            if index == 1 {
                if !(photoModel?.isVideo)! {
                    DYPhotosHelper.saveImageToAlbum(image: (photoModel?.image)!, complete: { (finish) in
                        debugPrint(finish ? "保存成功" : "保存失败")
                    })
                }
            }
        }
        
    }
}
