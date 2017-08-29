//
//  DYPhotoModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Photos

class DYPhotoModel: NSObject {

    var isSelect: Bool = false //标记是否选中
    var thumImage: UIImage? // 缩略图，列表用
    var cacheImage: UIImage?
    var asset: PHAsset? // 图片的资源
    var selectIndex: Int = 0// 选择的索引
    
    var videoURL: URL? // 视频的url
    
    var mediaName: String {
        return self.asset?.value(forKey: "filename") as! String
    }

    var videoDuration: Int {
        //视频长度
        if self.isVideo {
            return (self.asset?.value(forKey: "duration") as AnyObject).intValue
        }
        return 0
    }
    
    var isVideo: Bool {
        return self.asset?.mediaType == .video
    }
    
    func videoDurationShow() -> String{
    
        let second = videoDuration%60
        let minute = videoDuration/60
        return self.formatTime(time: minute) + ":" + self.formatTime(time: second)
    }
    
    private func formatTime(time: Int) -> String {
        if time < 10 {
            return "0" + String(time)
        }else{
            return String(time)
        }
    }
}
