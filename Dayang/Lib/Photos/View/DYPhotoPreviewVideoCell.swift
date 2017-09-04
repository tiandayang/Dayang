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
        requestVideoInfo()
    }
    
    private func requestVideoInfo() {
        if photoModel?.image != nil {
            videoView.image = photoModel?.image
        }else{
            self.requestVideoImage()
        }
        
        if photoModel?.videoURL != nil {
            videoView.videoURL = photoModel?.videoURL
        }else if photoModel?.videoPath != nil {
            videoView.videoURL = photoModel?.videoPath
        }else if photoModel?.asset != nil {
            DYPhotosHelper.requestVideoInfo(asset: (photoModel?.asset)!, complete: { (url) in
                self.photoModel?.videoURL = url.path
                self.videoView.videoURL = self.photoModel?.videoURL
                self.requestVideoImage()
            })
        }
    }
    
    private func requestVideoImage() {
        if photoModel?.videoURL != nil {
            DYPhotosHelper.getVideoDefaultImage(url: DYPhotosHelper.getURL(url: (photoModel?.videoURL)!), duration: 0, complete: { (image) in
                self.videoView.image = image
                self.photoModel?.image = image
            })
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
