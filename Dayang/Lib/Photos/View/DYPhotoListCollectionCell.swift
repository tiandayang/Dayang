//
//  DYPhotoListCollectionCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let  ITEMWIDTH = 2.0 * (WINDOW_WIDTH - 4*4)/3.0

class DYPhotoListCollectionCell: DYBaseCollectionViewCell {

    var photoModel: DYPhotoModel? {
        didSet{
            if photoModel != nil {
                videoButton.isHidden = !photoModel!.isVideo
                selectImageView.isHidden = !photoModel!.isSelect
               indexLabel.text = String(photoModel!.selectIndex)
                videoButton.setTitle(photoModel!.videoDurationShow(), for: .normal)
                videoButton.ajustImagePosition(position: .left, offset: 5)
                corverImage.image = photoModel?.thumImage
                
                if photoModel!.isVideo && photoModel?.videoURL == nil {
                    DYPhotosHelper.requestVideoInfo(asset: (photoModel?.asset)!, complete: { (videoUrl) in
                        self.photoModel?.videoURL = videoUrl
                    })
                }
                
                if photoModel?.thumImage == nil {
                    DYPhotosHelper.requestImage(asset: (photoModel?.asset)!, size: CGSize.init(width: SCALE_WIDTH(width: 130), height: SCALE_WIDTH(width: 130)), complete: { (image) in
                        self.corverImage.image = image
                        self.photoModel?.thumImage = image
                    })
                }
            }
        }
    }
    
    override func createUI() {
        contentView.addSubview(corverImage)
        contentView.addSubview(selectImageView)
        selectImageView.addSubview(indexLabel)
        contentView.addSubview(videoButton)
        
        corverImage.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        selectImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        indexLabel.snp.makeConstraints { (make) in
            make.right.top.equalTo(contentView);
            make.size.equalTo(CGSize(width: 25, height: 25));
        }
        
        videoButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(25)
        }
        
        selectImageView.isHidden = true
        indexLabel.isHidden = true
        videoButton.isHidden = true
    }

    lazy var corverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ch_selectbg_photo")
        return imageView
    }()
    
    lazy var selectImageView :UIImageView = {
        return UIImageView()
    }()
    
    lazy var indexLabel :UILabel = {
        let label = UILabel()
        label.font = UIFont.dy_systemFontWithSize(size: 14)
        label.textAlignment = .center
        label.textColor = .black
        
        return UILabel()
    }()
    
    lazy var videoButton: UIButton = {
        let button = UIButton.dyButton()
        button.isUserInteractionEnabled = false
        button.setImage(#imageLiteral(resourceName: "file_video"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
}
