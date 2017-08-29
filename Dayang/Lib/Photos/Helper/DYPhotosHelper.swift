//
//  DYPhotosHelper.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Photos

class DYPhotosHelper {

    /// 获取包含图片的相册列表
    ///
    /// - Parameter complete: 回调
    public class func getAllAlbumList(complete:(( _ array: [DYAlbumModel])->())?) {

        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                // 获取自定义相册
                let otherOptions = PHFetchOptions()
                otherOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
                var otherSort = [NSSortDescriptor]()
                otherSort.append(NSSortDescriptor(key: "startDate", ascending: true))
                otherOptions.sortDescriptors = otherSort
                let otherPhotos = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: otherOptions)
                
                // get all asset
                var allSort = [NSSortDescriptor]()
                let allPhotoOptions = PHFetchOptions()
                allSort.append(NSSortDescriptor(key: "creationDate", ascending: false))
                allPhotoOptions.sortDescriptors = allSort
                let allPhotos = PHAsset.fetchAssets(with: allPhotoOptions)
                
                var albumListArray = [DYAlbumModel]()
                
                let albumModel = DYAlbumModel()
                albumModel.albumName = "相机胶卷"
                albumModel.fetchAssets = allPhotos;
                albumModel.numberInCollection = allPhotos.count
                albumListArray.append(albumModel)
                
                for index  in 0...otherPhotos.count - 1 {
                    let albumModel = DYAlbumModel()
                    let collection = otherPhotos[index]
                    albumModel.albumName = collection.localizedTitle
                    let assetsFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
                    albumModel.numberInCollection = assetsFetchResult.count
                    albumModel.fetchAssets = assetsFetchResult
                    albumListArray.append(albumModel)
                }
                
                if complete != nil {
                    DispatchQueue.main.async {
                        complete!(albumListArray)
                    }
                }

            }
        }
        
    }
    
    /// 整理所有图片视频资源
    ///
    /// - Parameters:
    ///   - fetchAssets: 资源得集合
    ///   - complete: 回调
    public class func prepareAssetList(fetchAssets: PHFetchResult<PHAsset>, complete:((_ assetList: Array<DYPhotoModel>)->())?) {
        var assetListArray = [DYPhotoModel]()
        for index in 0...fetchAssets.count - 1 {
            let asset = fetchAssets[index]
            let photoModel = DYPhotoModel()
            photoModel.asset = asset;
            assetListArray.append(photoModel)
        }
        
        if complete != nil {
            complete!(assetListArray)
        }
    }
    
    /// 获取列表的缩略图
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - size: 大小
    ///   - complete: 回调
    public class func requestImage(asset: PHAsset,size: CGSize ,complete:((_ image: UIImage)->())?) {
        autoreleasepool { () in
            let imageManager = PHImageManager.default()
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: {(image, info)  in
                if complete != nil && image != nil {
                    DispatchQueue.main.async {
                        complete!(image!)
                    }
                }
            })
        }
    }
    
    public class func requestVideoInfo(asset: PHAsset ,complete:((_ videoURL: URL)->())?) {
        let imageManager = PHImageManager.default()
        imageManager.requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
            let  infoString = info?["PHImageFileSandboxExtensionTokenKey"]
            if infoString != nil && complete != nil {
                DispatchQueue.main.async {
                let url = URL.init(fileURLWithPath: (infoString as! NSString).components(separatedBy: ";").last!)
                complete!(url)
                }
            }
        }
    }
    
    
   ///  get authorizationStatus
   ///
   /// - Returns: 返回是不授权
   public class func isOpenAuthority() -> Bool {
        return PHPhotoLibrary.authorizationStatus() != .denied
    }
    
    
    // jumpToSetting handle  privacyAuth
   public class func jumpToSetting(){
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
    }

}
