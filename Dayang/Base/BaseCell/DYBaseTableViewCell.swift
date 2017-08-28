//
//  DYBaseTableViewCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYBaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
        createSubUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: CreateUI
    private func createUI() {
        contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.HexColor(hexValue: 0xf2f2f2)
        return view
    }()
    
    var isHiddenLine: Bool? {
        didSet{
            separatorLine.isHidden = isHiddenLine!
        }
    }
    
    
    //子类重写添加视图
    public func createSubUI() {}

}
