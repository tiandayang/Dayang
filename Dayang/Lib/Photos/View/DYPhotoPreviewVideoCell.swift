//
//  DYPhotoPreviewVideoCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/30.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYPhotoPreviewVideoCell: DYPhotoPreviewBaseCell {

    override func createUI() {
        super.createUI()
        self.contentView.addSubview(videoView)
        self.imageView = videoView
        videoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func setPhotoModel() {
     
        videoView.videoURL = photoModel?.videoURL
        if photoModel?.image != nil {
            videoView.image = photoModel?.image
        }else{
            if photoModel?.videoURL != nil {
               DYPhotosHelper.getVideoDefaultImage(url: DYPhotosHelper.getURL(url: (photoModel?.videoURL)!), duration: 0, complete: { (image) in
                self.videoView.image = image
                self.photoModel?.image = image
               })
            }
        }
    }
    
    var isDisplay: Bool = false { //是否正在展示
        didSet {
            videoView.isDisPlay = isDisplay
        }
    }

    lazy var videoView: DYVideoPlayerView = {
        let videoView = DYVideoPlayerView.init(frame: CGRect.zero)
        return videoView;
    }()
}
