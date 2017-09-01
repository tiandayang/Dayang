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
        videoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func setPhotoModel() {
     
        videoView.videoURL = photoModel?.videoURL
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
