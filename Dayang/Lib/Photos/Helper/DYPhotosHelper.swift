//
//  DYPhotosHelper.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Photos
import PromiseKit

class DYPhotosHelper {

    /// 获取包含图片的相册列表
    ///
    /// - Parameter complete: 回调
    public class func getAllAlbumList(mediaType: DYPhotoMediaType, complete:(( _ array: [DYAlbumModel])->())?) {

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
                albumModel.mediaType = mediaType
                albumListArray.append(albumModel)
                
                if otherPhotos.count > 0{
                    if otherPhotos.count == 1 {
                        let albumModel = DYAlbumModel()
                        let collection = otherPhotos[0]
                        albumModel.albumName = collection.localizedTitle
                        let assetsFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
                        albumModel.mediaType = mediaType
                        albumModel.fetchAssets = assetsFetchResult
                        albumListArray.append(albumModel)
                    }else{
                        for index  in 0...otherPhotos.count - 1 {
                            let albumModel = DYAlbumModel()
                            let collection = otherPhotos[index]
                            albumModel.albumName = collection.localizedTitle
                            let assetsFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
                            albumModel.mediaType = mediaType
                            albumModel.fetchAssets = assetsFetchResult
                            albumListArray.append(albumModel)
                        }
                    }
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
    public class func requestImage(asset: PHAsset,size: CGSize ,complete:dyRequestImageComplete?) {
        autoreleasepool { () in
            let imageManager = PHImageManager.default()
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: {(image, info)  in
                if complete != nil {
                    DispatchQueue.main.async {
                        complete!(image)
                    }
                }
            })
        }
    }
    
    /// 获取相册图片
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - isOrigin: 是否是原图
    ///   - complete: 回调 image对象
    public class func requestImage(asset: PHAsset, isOrigin: Bool, complete:dyRequestImageComplete?) {
        
        let options = PHImageRequestOptions()
        var scale = 0.8
        var size = CGSize.zero
        if isOrigin {
            size = PHImageManagerMaximumSize
            scale = 1
            options.deliveryMode = .highQualityFormat
        }else{
            options.deliveryMode = .fastFormat
            let imagePixel = Double(asset.pixelWidth * asset.pixelHeight)/(1024.0 * 1024.0)
            if imagePixel > 3  {
                size = CGSize(width: Double(asset.pixelWidth) * 0.5, height:Double(asset.pixelHeight) * 0.5)
                scale = 0.1
            }else if imagePixel > 2 {
                size = CGSize(width: Double(asset.pixelWidth) * 0.6, height:Double(asset.pixelHeight) * 0.6)
                scale = 0.2
            }else if imagePixel > 1 {
                size = CGSize(width: Double(asset.pixelWidth) * 0.6, height:Double(asset.pixelHeight) * 0.6)
                scale = 0.5
            }else{
                size = CGSize(width:asset.pixelWidth, height:asset.pixelHeight)
            }
        }
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options) { (image, info) in
            autoreleasepool{
                var resultImage = image
                if image != nil {
                    let imageData = UIImageJPEGRepresentation(image!, CGFloat(scale))
                    if imageData != nil {
                        resultImage = UIImage(data: imageData!)
                    }
                }
                DispatchQueue.main.async {
                    if complete != nil {
                        complete!(resultImage);
                    }
                }
            }
        }
    }
    
    /// 获取视频资源的信息
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - complete: 回调
    public class func requestVideoInfo(asset: PHAsset ,complete:((_ videoURL: URL)->())?) {
        let imageManager = PHImageManager.default()        
        imageManager.requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
            let  infoString = info?["PHImageFileSandboxExtensionTokenKey"]
            if infoString != nil && complete != nil {
                DispatchQueue.main.async {
                let url = URL(fileURLWithPath: (infoString as! NSString).components(separatedBy: ";").last!)
                complete!(url)
                }
            }
        }
    }
    
    public class func getVideoDefaultImage(url: URL,duration: TimeInterval, complete: dyRequestImageComplete?) {
        if complete == nil {
            return
        }
        
        let avAsset = AVURLAsset.init(url: url)
        let assetImageGenerator = AVAssetImageGenerator.init(asset: avAsset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels
        
        var cmTime = CMTimeMakeWithSeconds(duration, 30)
        if duration == 0 {
            cmTime = CMTimeMakeWithSeconds(duration, 1);
        }
        do {
             let thumbImageRef =  try assetImageGenerator.copyCGImage(at: cmTime, actualTime: nil)
            complete!(UIImage.init(cgImage: thumbImageRef))
        } catch _ {
            complete!(nil)
        }
        
    }
    
    // 根据地质类型生成URL
    public class func getURL(url: String) -> URL {
        if url.isNetUrl() {
            return URL.init(string: url)!
        }else{
            return URL.init(fileURLWithPath:url)
        }
    }
    
    /// 保存图片到相册
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - complete: 回调 是否保存成功
    public class func saveImageToAlbum(image: UIImage, complete:dyBoolComplete?) {
        let statusPromise = getAuthorizationStatus()
        statusPromise.then { (status) -> Promise<PHAssetCollection> in
            return  getCollection()
            }.then { (collection) in
                
                PHPhotoLibrary.shared().performChanges({
                    if #available(iOS 9.0, *) {
                        let newAsset = PHAssetCreationRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset
                        if newAsset == nil {
                            DispatchQueue.main.async {
                                if complete != nil{
                                    complete!(false)
                                }
                            }
                            return
                        }
                        let array = NSMutableArray()
                        array.add(newAsset!)
                        let request = PHAssetCollectionChangeRequest.init(for: collection)
                        request?.insertAssets(array, at: IndexSet.init(integer: 0))
                    } else {
                        UIImageWriteToSavedPhotosAlbum(image, DYPhotosHelper(), nil , nil)
                        if complete != nil{
                            complete!(true)
                        }
                    }
                }, completionHandler: { (finish, error) in
                    DispatchQueue.main.async {
                        if complete != nil{
                            complete!(finish)
                        }
                    }
                })
                
            }.catch { (error) in
                debugPrint(error)
                if complete != nil {
                    DispatchQueue.main.async {
                        complete!(false)
                    }
                }
        }

    }
    
    /// 保存视频到相册
    ///
    /// - Parameters:
    ///   - videoURL: 视频的本地路径
    ///   - complete: 回调
    public class func saveVideoToAlbum(videoPath: String, complete:dyBoolComplete?) {
        
        if !FileManager.default.fileExists(atPath: videoPath) {
            if complete != nil{
                complete!(false)
            }
            return
        }
        let videoURL = URL(fileURLWithPath: videoPath)
        let statusPromise = getAuthorizationStatus()
        statusPromise.then { (status) -> Promise<PHAssetCollection> in
            return getCollection()
        }.then { (collection) in
            PHPhotoLibrary.shared().performChanges({
                if #available(iOS 9.0, *) {
                    let newAsset = PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)?.placeholderForCreatedAsset
                    if newAsset == nil {
                        DispatchQueue.main.async {
                            if complete != nil{
                                complete!(false)
                            }
                        }
                        return
                    }
                    
                    let array = NSMutableArray()
                    array.add(newAsset!)
                    let request = PHAssetCollectionChangeRequest.init(for: collection)
                    request?.insertAssets(array, at: IndexSet.init(integer: 0))
                } else {
                    UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self,nil, nil)
                    DispatchQueue.main.async {
                        if complete != nil{
                            complete!(true)
                        }
                    }
                }
            }, completionHandler: { (finish, error) in
                DispatchQueue.main.async {
                    if complete != nil{
                        complete!(finish)
                    }
                }
            })
            
        }.catch { (error) in
            debugPrint(error)
            if complete != nil {
                DispatchQueue.main.async {
                    complete!(false)
                }
            }
        }
    }
    
    /// 获取项目的相册
    ///
    /// - Returns: 相册对象
    private class func getCollection() -> Promise<PHAssetCollection> {
        let promise = Promise<PHAssetCollection>{ (resolve,reject) in
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
            let appName = Bundle.main.infoDictionary?["CFBundleName"] as! String
            if collections.count > 0 {
                if collections.count == 1 {
                    let collection = collections[0]
                    if appName == collection.localizedTitle {
                        resolve(collection)
                        return
                    }
                }else{
                    for index in 0...collections.count - 1 {
                        let collection = collections[index]
                        if appName == collection.localizedTitle {
                            resolve(collection)
                            return
                        }
                    }
                }
            }
            
            PHPhotoLibrary.shared().performChanges({
                let collectionId = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: appName).placeholderForCreatedAssetCollection.localIdentifier
                PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionId], options: nil)
            }) { (finish, error) in
                if finish {
                    let reslutCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                    resolve(reslutCollections.lastObject!)
                }else{
                    let kError = NSError.init(domain: "创建相册失败", code: -1, userInfo: nil)
                    reject (error ?? kError)
                }
            }
        }
        return promise
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

   public class func getAuthorizationStatus()-> Promise<Int> {
        
        let promise = Promise<Int> { (resolve,reject)  in
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    resolve(status.rawValue)
                }else{
                    let error = NSError.init(domain: "未开启相册权限", code: -1, userInfo: nil)
                    reject(error as Error)
                }
            }
        }
        return promise
    }
}
