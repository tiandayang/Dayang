//
//  DYBannerView.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Kingfisher

private let kTimes = 10;

class DYBannerView: UIView {

    var bannerTapBlock:((_ bannerModel: DYBannerModel)->())? //点击事件
    var autoScroll: Bool = true // 默认自动滚动
    var timeInterval: TimeInterval = 3 //默认自动滚动时间间隔为 3 秒
    var timer: Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deinitTimer()
    }
    
    //MARK: Action
    
    func autoScrollAction() {
        let indexPaths = collectionView.indexPathsForVisibleItems
        if indexPaths.count > 0 {
            var currentIndexPath = indexPaths.last
            if (currentIndexPath?.item)! + 1 >= (bannerArray?.count)! * kTimes {
                self.collectionView.contentOffset = CGPoint(x:CGFloat((bannerArray?.count)! - 1) * self.mj_w,y: 0);
                currentIndexPath = IndexPath.init(item: (bannerArray?.count)! - 1, section: 0)
            }
            let nexIndexPath = IndexPath.init(item: (currentIndexPath?.item)! + 1, section: 0)
            collectionView.scrollToItem(at: nexIndexPath, at: .left, animated: true)
        }
    }
    
    func addTimer() {
        if autoScroll && (bannerArray?.count ?? 0) > 0 {
            timer = Timer.dy_scheduledTimer(timeInterval: timeInterval, repeats: true, block: { [weak self] in
                self?.autoScrollAction()
            })
        }
    }
    
    func deinitTimer() {
        timer?.invalidate()
        timer = nil
    }
    //MARK: CreateUI
    func createUI() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
    }
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DYBannerCollectionCell.self, forCellWithReuseIdentifier: "DYBannerCollectionCell")
        
        return collectionView
    }()

    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.hidesForSinglePage = true
        return page
    }()
    var bannerArray: [DYBannerModel]? {
        didSet{
            collectionView.reloadData()
            pageControl.numberOfPages = bannerArray?.count ?? 0
            addTimer()
        }
    }
}

extension DYBannerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return (bannerArray?.count ?? 0 ) * kTimes
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DYBannerCollectionCell", for: indexPath) as! DYBannerCollectionCell
        let model = self.bannerArray?.dy_objectAtIndex(index: indexPath.item % (bannerArray?.count)!)
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.bannerArray?.dy_objectAtIndex(index: indexPath.item % (bannerArray?.count)!)
        if bannerTapBlock != nil && model != nil {
            self.bannerTapBlock!(model!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.mj_size
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let offsetIndex = Int(collectionView.contentOffset.x / collectionView.mj_w)
        let pageIndex =  offsetIndex % (bannerArray?.count)!;
        pageControl.currentPage = pageIndex
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        ajustCollectionOffset()
    }
    
    func ajustCollectionOffset() {
        var offsetIndex = Int(collectionView.contentOffset.x / collectionView.mj_w)
        if (offsetIndex == 0 || offsetIndex == (self.collectionView.numberOfItems(inSection: 0) - 1)) {
            // 第 0 页
            if (offsetIndex == 0) {
                offsetIndex = self.bannerArray?.count ?? 0;
            } else {
                offsetIndex = (self.bannerArray?.count ?? 0) - 1;
            }
            // 重新调整 contentOffset
            collectionView.contentOffset = CGPoint(x:CGFloat(offsetIndex) * collectionView.mj_w, y: 0);
        }
    }
}

class DYBannerCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Action
    var model: DYBannerModel? {
        didSet{
            let url = URL(string: model?.icon ?? "")
            imageView.kf.setImage(with: url)
        }
    }
    
    //MARK: CreateUI
    func createUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    //MARK: lazyLoad
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

}

class DYBannerModel: DYBaseModel {
    var id: String?
    var name: String?
    var icon: String?
    
}