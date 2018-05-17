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
    
    //MARK: 本地图片
    var isSelect: Bool = false//标记是否选中
    var thumImage: UIImage? // 缩略图，列表用
    var asset: PHAsset? // 图片的资源
    var selectIndex: Int = 0// 选择的索引
    var isOriginImage: Bool = false // 是否是原图
    var cacheImage: UIImage? //取出来的图片  跟 isOriginImage 有关
    var resultImage: UIImage? //最终处理过要使用的图片
    var videoURL: URL? // 视频的url
    
    lazy var mediaName: String = {
        return self.asset?.value(forKey: "filename") as! String
    }()
    
    lazy var videoDuration: Int = {
        //视频长度
        if self.isVideo {
            return (self.asset?.value(forKey: "duration") as AnyObject).intValue
        }
        return 0
    }()
    
    lazy var isVideo: Bool = {
        return self.asset?.mediaType == .video
    }()
    
    
    /// 获取图片
    ///
    /// - Parameter complete: 图片的回调
    public func getCachedImage(complete: dyRequestImageComplete?) {
        
        if complete == nil {
            return
        }
        
        if cacheImage != nil {
            complete!(cacheImage)
        }else{
            if asset == nil {
                complete!(nil)
            }else{
                if isVideo && videoURL != nil {
                    DYPhotosHelper.getVideoDefaultImage(url: videoURL!, duration: 1, complete: { (image) in
                        self.cacheImage = image
                        complete!(image)
                    })
                }else{
                    DYPhotosHelper.requestImage(asset: self.asset!, isOrigin: self.isOriginImage, complete: { (image) in
                        complete!(image)
                        self.cacheImage = image
                    })
                }
            }
        }
    }
    
    public func getVideoURL(complete: ((_ videoUrl: URL)->(Void))?) {
        if complete == nil {
            return
        }
        if self.videoURL != nil {
            complete!(self.videoURL!)
        }else{
            if asset != nil {
                DYPhotosHelper.requestVideoInfo(asset: asset!) { (url) in
                    complete!(url)
                    self.videoURL = url
                }
            }
        }
    }
    
    /// 视频时长展示
    ///
    /// - Returns: string
    public func videoDurationShow() -> String{
        
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
