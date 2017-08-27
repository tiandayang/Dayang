//
//  DYGuideViewController.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let kGuideCount = 4;

class DYGuideViewController: DYBaseViewController {
    var nextBlock: (()->())?//动画完成的回调
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DOMGuideCollectionCell.self, forCellWithReuseIdentifier: "DOMGuideCollectionCell")
        
        return collectionView
    }()
    
    open let name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    //MARK:CreateUI
    func  createUI() {
        view.addSubview(collectionView)
    }
}

extension DYGuideViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    //MARK:UICollectionViewDelegate & dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kGuideCount;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DOMGuideCollectionCell", for: indexPath) as! DOMGuideCollectionCell
        cell.imageView.image = UIImage(named: String(indexPath.item))
        if indexPath.item == kGuideCount - 1 {
            cell.nextBlock = { [weak self] () in
                self?.nextClick()
            }
        }else{
            cell.nextBlock = nil
        }
        return cell
    }
    
    //MARK:下一步点击
    func nextClick() {
        UIView.animate(withDuration: 0.5, delay:0.5, options: .curveEaseInOut, animations: {
            self.view.alpha = 0
            self.view.transform = CGAffineTransform(translationX: -self.view.mj_w, y: 0)
        }) { (finish : Bool) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            // Save state
            UserDefaults.saveIsNotFirstInstall(isFirst: true)
            if (self.nextBlock != nil) {
                self.nextBlock!()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset = scrollView.contentOffset.x
        
        if offset > view.mj_w * CGFloat(kGuideCount - 1) {
            nextClick()
        }
    }
    
}

class DOMGuideCollectionCell:UICollectionViewCell {
    
    //MARK: lifeCycle
    override init(frame: CGRect){
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Action
    func nextClick(){
        if self.nextBlock != nil {
            self.nextBlock!()
        }
    }
    
    var nextBlock:(()->())? {
        didSet {
            if nextBlock == nil {
                nextButton.isHidden = true
            }else{
                nextButton.isHidden = false
            }
        }
    }
    
    //MARK: createUI
    func createUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(nextButton)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        nextButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.size.equalTo(CGSize(width: 115, height: 45))
        }
    }
    //MARK: lazyLoad
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setBackgroundImage(UIImage(named:"launch-goBuying"), for: .normal)
        button.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        return button
    }()
}
