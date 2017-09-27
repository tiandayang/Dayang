//
//  DYDownloadManager.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/5.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import RealmSwift

protocol DYDownloadManagerDelegate: NSObjectProtocol {
    func downloadingResponse(model: DYDownloadFileModel) // 异步回调
    func downloadComplete(model: DYDownloadFileModel)
    func downloadFaild(model: DYDownloadFileModel, error: Error?)
}

class DYDownloadManager: NSObject {
    static let shared = DYDownloadManager()  //构建单例对象
    private override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillBeKilled), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    var downloadQueue = OperationQueue() //下载队列 
    var delegate: DYDownloadManagerDelegate?
    
    lazy var tasks: Dictionary<String, URLSessionDataTask> = {
        let dictionary = Dictionary<String, URLSessionDataTask>()
        return dictionary
    }() //下载任务的字典
    
    lazy var streams: Dictionary<String,OutputStream> = {
        let dictionary = Dictionary<String,OutputStream>()
        return dictionary
    }()//下载流
    
    //MARK:  download
    /// 开启下载
    ///
    /// - Parameters:
    ///   - url: 下载的url
    ///   - progress: 进度block
    ///   - completed: 下载完成的block
    public func beginDownload(url: URL){
        
        let model = getFileModel(url: url)
        if model.value(forKeyPath: "dowloadState") as! Int == DYDownloadStatus.ing.rawValue {
            return;
        }
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: downloadQueue)
        var request = URLRequest(url: url)
        let headerRange = NSString.init(format: "bytes-%zd-", model.downloadSize)
        request.setValue(headerRange as String, forHTTPHeaderField: "Range")
        
        let urlTask = session.dataTask(with: request)
        tasks[model.fileUrlString] = urlTask;
        
         let outputStream = OutputStream(toFileAtPath: model.filePath, append: true)
        streams[model.fileUrlString] = outputStream;
        urlTask.resume()
    }
    
    /// 暂停某个任务
    ///
    /// - Parameter url: 链接
    public func suspend(url: String) {
        if let task = tasks[url] {
            task.suspend()
            DispatchQueue.main.async {
                let model = self.getFileModel(url: URL(string: url)!)
                try! DYRealm.write {
                    model.setValue(DYDownloadStatus.suspend.rawValue, forKey: "dowloadState")
                }
            }
        }else{
            DispatchQueue.main.async {
                let model = self.getFileModel(url: URL(string: url)!)
                try! DYRealm.write {
                    model.setValue(DYDownloadStatus.failed.rawValue, forKey: "dowloadState")
                }
                self.resume(url: url)
            }
        }
    }
    /// 开始某个任务
    ///
    /// - Parameter url: 链接
    public func resume(url: String) {
        if let task = tasks[url] {
            if task.state == URLSessionTask.State.canceling || task.state == URLSessionTask.State.completed {
                beginDownload(url: URL(string: url)!)
            }else{
                task.resume()
                DispatchQueue.main.async {
                    let model = self.getFileModel(url: URL(string: url)!)
                    try! DYRealm.write {
                        model.setValue(DYDownloadStatus.ing.rawValue, forKey: "dowloadState")
                    }
                }
            }
            
        }else{
            beginDownload(url: URL(string: url)!)
        }
    }
    /// 取消
    ///
    /// - Parameter url: 链接
    public func stop(url: String) {
        if let task = tasks[url] {
            task.cancel()
            DispatchQueue.main.sync {
                let model = getFileModel(url: URL(string: url)!)
                try! DYRealm.write {
                    model.setValue(DYDownloadStatus.failed.rawValue, forKey: "dowloadState")
                }
            }
        }
    }
    
   @objc func appWillBeKilled() {
    for model in allFiles {
        if (model.value(forKeyPath: "dowloadState") as! Int) == 3 {
            DispatchQueue.main.sync {
                try! DYRealm.write {
                    model.setValue(DYDownloadStatus.failed.rawValue, forKey: "dowloadState")
                }
            }
        }
    }
    }
    
    //MARK: helper
    /// 创建或者从从数据库获取model
    ///
    /// - Parameter url: 下载用到的链接
    /// - Returns: 返回 DYDownloadFileModel
    public func getFileModel(url: URL) -> DYDownloadFileModel {
     
        for model in allFiles {
            if model.fileUrlString == url.absoluteString {
                return model
            }
        }
        let model = DYDownloadFileModel()
        model.fileUrlString = url.absoluteString
        try! DYRealm.write {
            DYRealm.add(model)
        }
        return model;
    }
    
    var allFiles: Array<DYDownloadFileModel>! {
        let files = DYRealm.objects(DYDownloadFileModel.self)
        var filesArray = [DYDownloadFileModel]()
        for model in files {
            filesArray.append(model)
        }
        return filesArray
    }//所有文件
    
    /// 判断文件是否已经下载
    ///
    /// - Parameter fileURL: 文件的下载链接
    /// - Returns: 返回bool
    public func fileIsDowloaded(fileURL: String) -> Bool {
        for model in allFiles {
            if model.fileUrlString == fileURL {
                if FileManager.default.fileExists(atPath:model.value(forKeyPath: "filePath") as! String) && model.downloadSize == model.value(forKeyPath: "totalLength") as! Int64 {
                    return true;
                }
            }
        }
        return false
    }
    
    public func deleteFile(url: String) {
        let model = getFileModel(url: URL.init(string: url)!)
        WXXFileServer.removeFileAtPath(path: model.filePath)
        try! DYRealm.write {
            DYRealm.delete(model)
        }
    }
}

extension DYDownloadManager: URLSessionDelegate, URLSessionTaskDelegate,URLSessionDataDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let url = task.currentRequest?.url
        task.cancel()
        var stream = streams[(url?.absoluteString)!];
        stream?.close()

        DispatchQueue.main.sync {
          let  model = getFileModel(url: url!)
            if error != nil  {
                try! DYRealm.write {
                    model.setValue(DYDownloadStatus.failed.rawValue, forKey: "dowloadState")
                }
                if self.delegate != nil {
                    self.delegate?.downloadFaild(model: model, error: error)
                }
            } else {
                if model.downloadSize == model.value(forKeyPath: "totalLength") as! Int {
                    try! DYRealm.write {
                        model.setValue(DYDownloadStatus.completed.rawValue, forKey: "dowloadState")
                    }
                    stream = nil
                    streams[(url?.absoluteString)!] = nil
                }
                if self.delegate != nil {
                    self.delegate?.downloadComplete(model: model)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        DispatchQueue.main.sync {
        let model = getFileModel(url: response.url!)
            let httpResponse = response as! HTTPURLResponse;
            if let length = httpResponse.allHeaderFields["Content-Length"] {
                let totalSize = Int64((length as! String).toInt()) + model.downloadSize
                debugPrint("totalSize:",totalSize)
                let stream = streams[(response.url?.absoluteString)!];
                stream?.open()
                try! DYRealm.write {
                    model.setValue(DYDownloadStatus.ing.rawValue, forKey: "dowloadState")
                    model.setValue(Int64(totalSize), forKey: "totalLength")
                    model.setValue(String(totalSize), forKey: "totalSize")
                }
            }
        }
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let url = dataTask.currentRequest?.url
        let array = [UInt8](data)
        let stream = self.streams[(url?.absoluteString)!];
        stream?.write(array, maxLength: data.count)
        DispatchQueue.main.sync {
            let model = getFileModel(url: url!)
            if self.delegate != nil {
                self.delegate?.downloadingResponse(model: model)
            }
        }
    }
}
