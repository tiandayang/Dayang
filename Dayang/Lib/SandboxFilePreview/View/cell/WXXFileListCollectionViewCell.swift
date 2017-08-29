//
//  WXXFileListCollectionViewCell.swift
//  SandboxFileManager
//
//  Created by 田向阳 on 2017/8/17.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import SnapKit

protocol WXXFileListCollectionViewCellDelegate: NSObjectProtocol {
    //删除操作
    func deleteAction(fileModel: WXXFileListModel)
    //开始删除晃动动画
    func startDeleteAnimation()
}

class WXXFileListCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: WXXFileListCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:Action
   @objc private func deleteAction() {
        WXXCellAnimation.deleteAnimation(view: self)
    }
    
    //MARK: configData
    var model: WXXFileListModel? {
        didSet{
            self.iconView.image = model?.fileIcon;
            self.nameLabel.text = model?.fileName;
        }
    }
    
    //MARK: CreateUI
   private func createUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(deleteButton)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview().offset(-25)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setImage(UIImage(named: "File_delete"), for: .normal)
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return button
    }()
}

extension WXXFileListCollectionViewCell: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim.value(forKeyPath: "keyPath") as? String == "transform.scale" {
            if self.delegate != nil  && self.model != nil {
                self.delegate?.deleteAction(fileModel: self.model!)
            }
        }
    }
}
