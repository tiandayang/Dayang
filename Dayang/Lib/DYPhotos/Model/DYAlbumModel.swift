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
    var mediaType: DYPhotoMediaType = .both
    var assetList = [DYPhotoModel]()
    
    var fetchAssets: PHFetchResult<PHAsset>? {
        didSet{
            var assetListArray = [DYPhotoModel]()
            if fetchAssets != nil && (fetchAssets?.count)! > 0{
                for index in 0...(fetchAssets?.count)! - 1 {
                    let asset = fetchAssets?[index]
                    let photoModel = DYPhotoModel()
                    photoModel.asset = asset;
                    assetListArray.append(photoModel)
                }
            }
            switch self.mediaType {
            case .image:
                self.assetList = assetListArray.filter({ (mode) -> Bool in
                    return !mode.isVideo
                })
                break
            case .video:
                self.assetList =  assetListArray.filter({ (mode) -> Bool in
                    return mode.isVideo
                })
                break
            case .both:
                self.assetList = assetListArray
                break
            }
        }
    }
    
}
