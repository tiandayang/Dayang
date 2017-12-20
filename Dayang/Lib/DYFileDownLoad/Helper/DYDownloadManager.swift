//
//  DYDownloadManager.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/5.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import RealmSwift

private let maxDownloadCount = 3;

protocol DYDownloadManagerDelegate: NSObjectProtocol {
    func downloadingResponse(model: DYDownloadFileModel)
    func downloadComplete(model: DYDownloadFileModel)
    func downloadFaild(model: DYDownloadFileModel, error: Error?)
}

public class DYDownloadManager: NSObject {
    static let shared = DYDownloadManager()  //构建单例对象
    private override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillBeKilled), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        downloadQueue.maxConcurrentOperationCount = maxDownloadCount;
        downloadQueue.name = "com.dY.DYFileDowload"
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
    
    var downloadingArray: Array<DYDownloadFileModel> {
        return allFiles.filter({ (model) -> Bool in
            return model.downloadStatus == .ing;
        })
    }
    
    var waitArray: Array<DYDownloadFileModel> {
        return allFiles.filter({ (model) -> Bool in
            return model.downloadStatus == .wait;
        })
    } //等待的数量
    
    //MARK:  download
    /// 开启下载
    ///
    /// - Parameters:
    ///   - url: 下载的url
    ///   - progress: 进度block
    ///   - completed: 下载完成的block
    public func beginDownload(url: URL){
        
        var model = getFileModel(url: url)
        if model != nil && model?.downloadStatus == .ing {
            return;
        }else if model == nil {
          model = saveToDB(url: url)
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: downloadQueue)
        var request = URLRequest(url: url)
        let headerRange = NSString.init(format: "bytes-%zd-", model?.downloadSize ?? 0)
        request.setValue(headerRange as String, forHTTPHeaderField: "Range")
        
        let urlTask = session.dataTask(with: request)
        tasks[url.absoluteString] = urlTask;
        
        let outputStream = OutputStream(toFileAtPath: (model?.filePath)!, append: true)
        streams[url.absoluteString] = outputStream;
        if downloadingArray.count >= maxDownloadCount {
            try! DYRealm.write {
                model?.setValue(DYDownloadStatus.wait.rawValue, forKey: "downloadState")
            }
        }else{
            urlTask.resume()
        }
    }
    
    /// 暂停某个任务
    ///
    /// - Parameter url: 链接
    public func suspend(url: String) {
        if let task = tasks[url] {
            task.suspend()
           dy_safeAsync {
            if let model = self.getFileModel(url: URL(string: url)!) {
                try! DYRealm.write {
                    model.setValue(DYDownloadStatus.suspend.rawValue, forKey: "downloadState")
                }
            }
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
                dy_safeAsync {
                    if let model = self.getFileModel(url: URL(string: url)!) {
                        try! DYRealm.write {
                            model.setValue(DYDownloadStatus.ing.rawValue, forKey: "downloadState")
                        }
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
            dy_safeAsync {
                if let model = self.getFileModel(url: URL(string: url)!) {
                    try! DYRealm.write {
                        model.setValue(DYDownloadStatus.failed.rawValue, forKey: "downloadState")
                    }
                }
            }
        }
    }
    //程序即将被杀掉
   @objc func appWillBeKilled() {
    for model in downloadingArray {
        let stream = self.streams[model.fileUrlString]
        let task = self.tasks[model.fileUrlString]
        task?.suspend()
        stream?.close()
        try! DYRealm.write {
            model.setValue(DYDownloadStatus.failed.rawValue, forKey: "downloadState")
        }
    }
    }
    
    //MARK: helper
    /// 创建或者从从数据库获取model
    ///
    /// - Parameter url: 下载用到的链接
    /// - Returns: 返回 DYDownloadFileModel
     func getFileModel(url: URL) -> DYDownloadFileModel? {
     
        for model in allFiles {
            if model.fileUrlString == url.absoluteString {
                return model
            }
        }
        return nil
    }
    
    fileprivate func saveToDB(url: URL) -> DYDownloadFileModel {
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
                if FileManager.default.fileExists(atPath:model.value(forKeyPath: "filePath") as! String) && model.downloadSize == model.totalLength {
                    return true;
                }
            }
        }
        return false
    }
    
    /// 删除下载记录
    ///
    /// - Parameter url: url
    public func deleteFile(url: String) {
        if let model = getFileModel(url: URL.init(string: url)!) {
            if model.downloadStatus == .ing {
                suspend(url: url)
            }
            WXXFileServer.removeFileAtPath(path: model.filePath)
            try! DYRealm.write {
                DYRealm.delete(model)
            }
            checkAutoDownLoad()
        }
    }
    
    /// 检查有无等待中的任务 有的话 就去自动下载
    fileprivate func checkAutoDownLoad() {
        if waitArray.count > 0 && downloadingArray.count < maxDownloadCount{
            beginDownload(url:URL.init(string: (waitArray.first?.fileUrlString)!)!)
        }
    }
}

extension DYDownloadManager: URLSessionDelegate, URLSessionTaskDelegate,URLSessionDataDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let url = task.currentRequest?.url
        var stream = streams[(url?.absoluteString)!];
        stream?.close()
        
        if ((error as NSError?)?.code == -999){
            return;   // cancel
        }
        dy_safeAsync {
            if let  model = self.getFileModel(url: url!) {
                if error != nil  {
                    try! DYRealm.write {
                        model.setValue(DYDownloadStatus.failed.rawValue, forKey: "downloadState")
                    }
                    if self.delegate != nil {
                        self.delegate?.downloadFaild(model: model, error: error)
                    }
                } else {
                    if model.downloadSize == model.totalLength {
                        try! DYRealm.write {
                            model.setValue(DYDownloadStatus.completed.rawValue, forKey: "downloadState")
                        }
                        stream = nil
                        self.tasks.removeValue(forKey: (url?.absoluteString)!)
                        self.streams.removeValue(forKey: (url?.absoluteString)!)
                    }
                    if self.delegate != nil {
                        self.delegate?.downloadComplete(model: model)
                    }
                }
            }
            //下载任务结束后 自动检查有无等待中的任务 有的话自动下载
            self.checkAutoDownLoad()
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        dy_safeAsync {
            if let model = self.getFileModel(url: response.url!) {
                let httpResponse = response as! HTTPURLResponse;
                if let length = httpResponse.allHeaderFields["Content-Length"] {
                    let totalSize = Int64((length as! String).toInt()) + model.downloadSize
                    debugPrint("totalSize:",totalSize)
                    let stream = self.streams[(response.url?.absoluteString)!];
                    stream?.open()
                    try! DYRealm.write {
                        model.setValue(DYDownloadStatus.ing.rawValue, forKey: "downloadState")
                        model.setValue(String(totalSize), forKey: "totalSize")
                    }
                }
            }
        }
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let url = dataTask.currentRequest?.url
        let array = [UInt8](data)
        let stream = self.streams[(url?.absoluteString)!];
        stream?.write(array, maxLength: data.count)
        dy_safeAsync {
            if let model = self.getFileModel(url: url!) {
                if self.delegate != nil {
                    self.delegate?.downloadingResponse(model: model)
                }
            }
        }
    }
}
