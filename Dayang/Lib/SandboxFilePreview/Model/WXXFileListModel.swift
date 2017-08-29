//
//  FileListModel.swift
//  SandboxFileManager
//
//  Created by 田向阳 on 2017/8/17.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

enum FileType: String {
    case none   = "large_unknown"    //未知类型
    case folder = "large_file"  // 文件夹
    case zip    = "large_zip"     //压缩文件
    case image  = "large_pic"   //图片
    case video  = "large_ai"   //视频
    case audio  = "large_music"   //语音
    case word   = "large_word"    //文档
    case excel  = "large_xls"   //表格
    case ppt    = "large_ppt"     //幻灯片
    case pdf    = "large_pdf"     //PDF文档
    case db     = "db"      //数据库
    case txt    = "large_txt" //文本
    case html    = "large_doc" //网页
}

class WXXFileListModel: NSObject {
    var filePath: String = ""
    
    var fileName: String {
        if let name = (self.filePath as NSString?)?.lastPathComponent {
            return name
        }
        return ""
    }
    
    var fileExt: String {
        if let ext = (fileName as NSString?)?.pathExtension.lowercased() {
            return ext
        }
        return ""
    }
    
    var fileType: FileType {
        var isDir : ObjCBool = false
        if  FileManager.default.fileExists(atPath: self.filePath, isDirectory: &isDir) {
            if isDir.boolValue {
                return .folder
            }else{
                if fileExt == "zip" || fileExt == "rar" {
                    return .zip
                }
                if fileExt == "jpg" || fileExt == "png" || fileExt == "jpeg" || fileExt == "gif" {
                    return .image
                }
                if fileExt == "pdf" {
                    return .pdf
                }
                if fileExt == "ppt" || fileExt == "pptx"{
                    return .ppt
                }
                if fileExt == "doc" || fileExt == "docx" {
                    return .word
                }
                if fileExt == "xls" || fileExt == "xlsx" {
                    return .excel
                }
                if fileExt == "mp4" || fileExt == "mov" {
                    return .video
                }
                if fileExt == "mp3" || fileExt == "wav" || fileExt == "wma" || fileExt == "amr"{
                    return .audio
                }
                if fileExt == "txt" || fileExt == "rtf" || fileExt == "plist" {
                    return .txt
                }
                if fileExt == "html"{
                    return .html
                }
            }
        }
        return .none
    }
    
    var fileIcon: UIImage? {
        let imageName = fileType.rawValue
        return UIImage(named: imageName)
    }
}
