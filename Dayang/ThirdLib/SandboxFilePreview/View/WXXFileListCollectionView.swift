//
//  WXXFileListCollectionView.swift
//  SandboxFileManager
//
//  Created by 田向阳 on 2017/8/17.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let numberOfRow = 3;
private let itemSpace = 10;

class WXXFileListCollectionView: UIView {

    open var didSelectRowBlock: ((_ model: WXXFileListModel)->())?
    fileprivate var isEditing: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Action
    
    var fileListArray: [WXXFileListModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: CreateUI
    func createUI() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let space = CGFloat(itemSpace);
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space)
        
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WXXFileListCollectionViewCell.self, forCellWithReuseIdentifier: "WXXFileListCollectionViewCell")
        return collectionView
    }()
}

extension WXXFileListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WXXFileListCollectionViewCellDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.fileListArray != nil {
            return (self.fileListArray?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WXXFileListCollectionViewCell", for: indexPath) as! WXXFileListCollectionViewCell
        let model = self.fileListArray?[indexPath.row]
        cell.model = model
        updateCellState(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            return
        }
        
        if self.didSelectRowBlock != nil {
            let model = self.fileListArray?[indexPath.row]
            self.didSelectRowBlock!(model!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        let itemWidth = (collectionWidth - CGFloat(itemSpace * 2) - CGFloat((numberOfRow - 1) * 10))/CGFloat(numberOfRow) - 0.1;
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func updateCellState(cell: WXXFileListCollectionViewCell, indexPath: IndexPath) {
        cell.delegate = self
        cell.deleteButton.isHidden = !isEditing;
        if isEditing {
            WXXCellAnimation.shakeAnimation(view: cell)
        }else{
            cell.layer.removeAnimation(forKey: "shake")
        }
    }
    
    //删除动画
    func deleteAction(fileModel: WXXFileListModel) {

        collectionView.performBatchUpdates({
            
            let index = self.fileListArray?.index(of: fileModel)
            let indexPath = IndexPath.init(item: index!, section: 0)
            self.fileListArray?.remove(at: index!)
            self.collectionView.deleteItems(at: [indexPath])
            WXXFileServer.removeFileAtPath(path: fileModel.filePath)
        }) { (finish) in}
    }
    //晃动动画
    func startDeleteAnimation() {
        if !isEditing {
            self.isEditing = true
            self.collectionView.reloadData()
        }
    }
    
    func endShakeAnimation() {
        if isEditing {
            isEditing = false
            self.collectionView.reloadData()
        }
    }
        
}
