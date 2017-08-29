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

typealias selectComplete = ((_ selectArray: Array<DYPhotoModel>)->()) //选择完成的回调
