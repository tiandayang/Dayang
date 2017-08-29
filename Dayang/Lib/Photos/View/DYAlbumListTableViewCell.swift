//
//  DYAlbumListTableViewCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let imageWidth = 60
private let leftEdge   = 14

class DYAlbumListTableViewCell: DYBaseTableViewCell {

    override func createSubUI() {
        
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(titleLabel)
        contentView.addSubview(corverImage)
        contentView.addSubview(detailLabel)
        corverImage.backgroundColor = UIColor.red
        corverImage.clipsToBounds = true
        corverImage.contentMode = .scaleAspectFill
        titleLabel.font = UIFont.dy_boldSystemFontWithSize(size: 18)
        corverImage.backgroundColor = UIColor.HexColor(hexValue: 0xf2f2f2)
        
        corverImage.snp.makeConstraints({ (make) in
            make.left.equalTo(leftEdge);
            make.width.equalTo(imageWidth);
            make.height.equalTo(imageWidth);
            make.centerY.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.corverImage.snp.right).offset(leftEdge);
            make.right.equalTo(-leftEdge);
            make.top.equalTo(self.corverImage.snp.top);
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.left);
            make.right.equalTo(self.titleLabel.snp.right);
            make.bottom.equalTo(self.corverImage.snp.bottom);
        }
    }
    
    lazy var titleLabel: UILabel = {
        return  UILabel()
    }()
    
    lazy var corverImage: UIImageView = {
        return UIImageView()
    }()
    
    lazy var detailLabel: UILabel = {
        return  UILabel()
    }()
    
    var albumModel: DYAlbumModel? {
        didSet{
            if albumModel != nil {
                titleLabel.text = albumModel!.albumName
                detailLabel.text = String(albumModel!.assetList.count)
                if albumModel?.albumCorver != nil {
                    self.corverImage.image = albumModel?.albumCorver
                }else{
                    if (albumModel!.fetchAssets?.count ?? 0) > 0 {
                        DYPhotosHelper.requestImage(asset: (albumModel!.fetchAssets?.firstObject)!, size: CGSize.init(width: 100, height: 100), complete: { (image) in
                            self.corverImage.image = image
                            self.albumModel?.albumCorver = image
                        })
                    }
                }

            }
        }
    }
}
