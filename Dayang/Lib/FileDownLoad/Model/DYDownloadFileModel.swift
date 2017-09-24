//
//  DYDownloadFileModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/5.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

/// 文件类型
enum DYFileType: Int {
    case none = 0      //未知类型
    case folder  = 1    // 文件夹
    case zip   = 2     //压缩文件
    case image = 3     //图片
    case video = 4     //视频
    case audio = 5     //语音
    case word  = 6     //文档
    case excel = 7     //表格
    case ppt   = 8     //幻灯片
    case pdf   = 9     //PDF文档
    case db    = 10     //数据库
    case txt   = 11     //文本
    case html  = 12     //网页
}


/// 下载状态
enum DYDownloadStatus: Int {
    case unKnown  = 0//未知状态
    case none   = 1  //未下载
    case wait   = 2  // 等待中
    case ing    = 3 // 正在下载
    case suspend  = 4// 暂停
    case failed  = 5// 下载失败
    case completed  = 6 // 已完成
}

class DYDownloadFileModel: DYBaseModel {
    
    dynamic var fileUrlString: String!// 文件的下载链接
    open var dowloadState: Int = 0 //数据库用
    open var totalSize: String = "0" //总长度
    open var icon: String? //文件的链接icon
    
    lazy var stream: OutputStream? = {
        if self.dowloadState != DYDownloadStatus.completed.rawValue {
            let outputStream = OutputStream(toFileAtPath: self.filePath, append: true)
            return outputStream
        }
        return nil
    }()//下载流
    
    open var downloadStatus: DYDownloadStatus = .none {
        didSet{
            self.dowloadState = downloadStatus.rawValue
        }
    }
    open var totalLength: Int64 = 0 {
        didSet{
            self.totalSize = String(totalLength)
        }
    } //文件总大小
    open var progress: Double {
        if (value(forKeyPath: "totalLength") as! Int) > 0 {
            return Double(downloadSize)/Double(value(forKeyPath: "totalLength") as! Int)
        }
        return 0.0
    }; //下载进度

    
    open var fileURL: URL! { // 文件的下载链接
        return URL.init(string: fileUrlString)
    }
    
    open var downloadSize: Int64 {
        let fileManager = FileManager.default
        do {
            let att = try fileManager.attributesOfItem(atPath: filePath)
            return att [FileAttributeKey.size] as! Int64
        } catch _ {
            return 0
        }
    }
    
    lazy var fileName: String =   {
        let name = self.fileURL.lastPathComponent
        return name
    }()
    
    open var fileType: DYFileType {
        let ext = fileURL.pathExtension
        if ext == "zip" {
            return .zip
        }
        if ext == "jpg" || ext == "png" || ext == "jpeg" || ext == "gif" {
            return .image
        }
        if ext == "pdf" {
            return .pdf
        }
        if ext == "ppt" || ext == "pptx"{
            return .ppt
        }
        if ext == "doc" || ext == "docx" {
            return .word
        }
        if ext == "xls" || ext == "xlsx" {
            return .excel
        }
        if ext == "mp4" || ext == "mov" {
            return .video
        }
        if ext == "mp3" || ext == "wav" || ext == "wma" {
            return .audio
        }
        if ext == "txt" || ext == "rtf" || ext == "plist" {
            return .txt
        }
        if ext == "html"{
            return .html
        }
        return .none
    }
    
    open var filePath: String {
        let fileName = fileUrlString.md5().appendingFormat(".%@", fileURL.pathExtension)
        switch fileType {
        case .image:
            return DYLocalFilePathServer.imagePath().appendingFormat("/%@", fileName)
        case .video:
            return DYLocalFilePathServer.videoPath().appendingFormat("/%@", fileName)
        default:
            return DYLocalFilePathServer.otherPath().appendingFormat("/%@", fileName)
        }
    }
    
    override static func primaryKey() -> String? {
        return "fileUrlString"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["stream","progress","downloadSize","filePath","fileName","fileType","fileURL","downloadStatus"]
    }
}

