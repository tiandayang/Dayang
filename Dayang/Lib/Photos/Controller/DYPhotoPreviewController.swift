//
//  DYPhotoPreviewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYPhotoPreviewController: DYBaseViewController {
    
    open var thumbTapView: UIImageView?// 点击的view
    open var tapSuperView: UIScrollView? // imageView的滚动父视图  collectionView 或者 tableView
    
    open var dataArray: Array<DYPhotoPreviewModel>?{
        didSet{
            loadData()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        collectionView.backgroundColor = .black
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: DYPhotoPreviewVideoCell.self) {
            (cell as! DYPhotoPreviewVideoCell).isDisplay = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: DYPhotoPreviewVideoCell.self) {
            (cell as! DYPhotoPreviewVideoCell).isDisplay = false
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
                        let title = finish ? "保存成功" : "保存失败"
                        debugPrint(title)
                        DYHUDHelper.showSuccessHUD(inView: self.view, title: title, isSuccess: finish)
                    })
                }else{
                    if photoModel?.videoPath != nil {
                        DYPhotosHelper.saveVideoToAlbum(videoPath:(photoModel?.videoPath)!, complete: { (finish) in
                            let title = finish ? "保存成功" : "保存失败"
                            debugPrint(title)
                            DYHUDHelper.showSuccessHUD(inView: self.view, title: title, isSuccess: finish)
                        })
                    }
                }
            }
        }
        
    }
}

//动画的代理
extension DYPhotoPreviewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DYPhotoPreviewAnimation.init(thumbTapView: self.thumbTapView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DYPhotoPreviewAnimation.init(thumbTapView: self.thumbTapView)
    }
}
