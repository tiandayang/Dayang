//
//  DYAlbumModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Photos

class DYAlbumModel {

    var albumName: String?
    var albumCorver: UIImage?
    var fetchAssets: PHFetchResult<PHAsset>?
    var mediaType: DYPhotoMediaType = .both
    lazy var assetList: [DYPhotoModel] = {
        var assetListArray = [DYPhotoModel]()
        if self.fetchAssets != nil {
            for index in 0...(self.fetchAssets?.count)! - 1 {
                let asset = self.fetchAssets?[index]
                let photoModel = DYPhotoModel()
                photoModel.asset = asset;
                assetListArray.append(photoModel)
            }
        }
        switch self.mediaType {
        case .image:
            return assetListArray.filter({ (mode) -> Bool in
                return !mode.isVideo
            })
        case .video:
            return assetListArray.filter({ (mode) -> Bool in
                return mode.isVideo
            })
        case .both:
            return assetListArray
        }
    }()
}
