//
//  DYCache.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

let autoDeleteTime = 60 * 60 * 24 * 7; // 1 week
let defaultMemorySize = 20 * 1024 * 1024; //20M

class DYCache: NSObject {
    
    public static let shared = DYCache()
    
    override init() {
        super.init()
        let path = self.cachePathDirectory()
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch _ {}
        }
        self.addNotification()
    }
    
    lazy var memoryCache: NSCache<AnyObject,AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        return cache
    }()
    
    var maxMemorySize: Int = defaultMemorySize { // 内存的缓存空间大小
        didSet{
            memoryCache.totalCostLimit = maxMemorySize
        }
    }
    var maxMemoryCount: Int = 100 { //内存缓存最大数量
        didSet{
            memoryCache.countLimit = maxMemoryCount
        }
    }
    
    var maxDiskCacheSize: Int = 50 * 1024 * 1024 //硬盘最大存储空间

    lazy var ioQueue: DispatchQueue = {
        let queue = DispatchQueue.init(label: "dyCache.ioQueue")
        return queue
    }()
    
    fileprivate func cachePathDirectory() -> String {
        return DYLocalFilePathServer.cachePath() + "/dyCache"
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEndterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearMemory), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
}

extension DYCache {
    
    /// 缓存data
    ///
    /// - Parameters:
    ///   - obj: 对象
    ///   - key: key
    public func store(obj: Data,key: String) {
        self.memoryCache.setObject(obj as AnyObject, forKey: key as AnyObject, cost: obj.count)
        // 缓存到硬盘
        self.ioQueue.async {
            let path = self.getCachePath(key: key)
            FileManager.default.createFile(atPath: path, contents: obj, attributes: nil)
        }
    }
    
    public func getObject(key: String) -> Data? {
        if let data = self.memoryCache.object(forKey: key as AnyObject) {
            return data as? Data
        }else{
            let path = self.getCachePath(key: key)
            if FileManager.default.fileExists(atPath: path) {
                let data = NSData.init(contentsOfFile: path)
                return data as Data?
            }
        }
        return nil
    }
    
    public func remove(key: String) {
        self.memoryCache.removeObject(forKey: key as AnyObject)
        self.ioQueue.async {
            let path = self.getCachePath(key: key)
            WXXFileServer.removeFileAtPath(path: path)
        }
    }
    
    public func clearMemory(){
        self.memoryCache.removeAllObjects()
    }
    
    public func clearDisk() {
        self.ioQueue.async {
            let path = self.cachePathDirectory()
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch _ {}
            }
        }
    }
    
    public func appDidEndterBackground() {
        checkIsNeedToClearDisk {}
    }
    
    public func checkIsNeedToClearDisk(_ complete: (() -> (Void))?) {
        self.ioQueue.async {
            let cacheURL = self.cachePathDirectory()
            let resourceKeys = [URLResourceKey.isDirectoryKey,URLResourceKey.contentModificationDateKey,URLResourceKey.totalFileAllocatedSizeKey]
            if let fileEnumerator = FileManager.default.enumerator(at: URL.init(fileURLWithPath: cacheURL), includingPropertiesForKeys: resourceKeys){
                let expireDate = Date.init(timeIntervalSinceNow: TimeInterval(-autoDeleteTime))
                let cacheFiles = Dictionary<URL,URLResourceValues>() as NSDictionary
                var cacheCurrentSize = 0
                var urlsToDel = [URL]()
                for url in fileEnumerator {
                    let url = url as! URL
                    do{
                        let att = try url.resourceValues(forKeys: Set.init(resourceKeys))
                        if att.isDirectory ?? false {
                            continue
                        }
                        let fileDate = (att.contentModificationDate ?? Date()) as NSDate
                        let compareDate = fileDate.laterDate(expireDate) as NSDate
                        if compareDate.isEqual(to: expireDate) {
                            urlsToDel.append(url)
                            continue
                        }
                     let fileSize = att.totalFileAllocatedSize ?? 0
                        cacheCurrentSize += fileSize
                        cacheFiles.setValue(att, forKey: url.path)
                    } catch _{}
                }
                
                for url in urlsToDel {
                    WXXFileServer.removeFileAtPath(path: url.path)
                }
                if self.maxDiskCacheSize > 0 && cacheCurrentSize > self.maxDiskCacheSize {
                   let desiredCacheSize = self.maxDiskCacheSize / 2
                 
                    let sortFiles: [URL] = cacheFiles.keysSortedByValue(options: NSSortOptions.concurrent, usingComparator: { (obj1, obj2) -> ComparisonResult in
                        let obj1 = obj1 as! URLResourceValues
                        let obj2 = obj2 as! URLResourceValues
                        return obj1.contentModificationDate!.compare(obj2.contentModificationDate!)
                    }) as! [URL]
                    for url in sortFiles {
                        let att = cacheFiles[url.path] as! URLResourceValues
                        let size = att.totalFileAllocatedSize ?? 0
                        cacheCurrentSize -= size
                        if cacheCurrentSize < desiredCacheSize {
                            break
                        }
                    }
                }
                
                if complete != nil {
                    dy_safeAsync({
                        complete!()
                    })
                }
            }
        }
    }
    
    public func getLocalCacheSize() -> Int64 {
        var size = 0
        self.ioQueue.sync {
            if let enumerator = FileManager.default.enumerator(atPath: self.cachePathDirectory()) {
                for fileName in enumerator {
                    let path = self.cachePathDirectory() + "/\(fileName)"
                    do {
                       let att = try FileManager.default.attributesOfItem(atPath: path)
                        size += att[FileAttributeKey.size] as! Int
                    } catch _ {}
                }
            }
        }
        return Int64(size)
    }
    
    fileprivate func getCachePath(key: String) -> String {
        return self.cachePathDirectory() + "/\(key)"
    }
}
