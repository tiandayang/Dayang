//
//  DYPhotosMenuView.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/30.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYPhotosMenuView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: CreateUI
    func createUI() {
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    lazy var button: UIButton = {
        let button = UIButton.dyButton()
        button.setImage(#imageLiteral(resourceName: "photo_look"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
}
