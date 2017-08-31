//
//  DYPhotosHeader.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

enum DYPhotoMediaType: Int {
    case image
    case video
    case both 
}

typealias dySelectImagesComplete = ((_ selectArray: Array<DYPhotoModel>)->()) //选择所有完成的回调

typealias dySelectImageComplete = ((_ image: UIImage?)->()) // 获取图片的回调

typealias dyBoolComplete = ((_ success: Bool)->()) //带有bool 回调值的block
