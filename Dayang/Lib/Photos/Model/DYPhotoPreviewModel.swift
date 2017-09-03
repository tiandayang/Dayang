//
//  DYPhotoPreviewModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/31.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Photos

class DYPhotoPreviewModel: NSObject {
    //MARK: 图片
    var imageURL: String? //图片的链接
    var imagePath: String? //图片的路径 
    
    //MARK: 视频
    var videoURL: String? //视频的url
    var videoPath: String? //视频的本地路径
    var isFileURL: Bool {  //是否是本地路径
        if self.videoURL != nil {
            return !self.videoURL!.isNetUrl()
        }
        return false
    }
    //MARK: 公共
    var asset: PHAsset? // 本地相册的资源
    var image: UIImage? //图片的image 或者是视频的第一帧
    var thumbImage: UIImage? //默认占位图
    var isVideo: Bool = false //是否是视频
        
}
