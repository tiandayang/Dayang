//
//  DYBaseCollectionViewCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYBaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: CreateUI
   public func createUI() {
    //子类重写吧
    }
}
