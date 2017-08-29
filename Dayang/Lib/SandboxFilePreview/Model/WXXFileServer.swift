//
//  FileServer.swift
//  SandboxFileManager
//
//  Created by 田向阳 on 2017/8/17.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class WXXFileServer: NSObject {
    
    class func getSubFolder(path: String?) -> [WXXFileListModel] {
        var fileListArray = [WXXFileListModel]();
        if path != nil {
            do {
             let array = try  FileManager.default.contentsOfDirectory(atPath: path!)
                if array.count > 0 {
                    for subPath in array {
                        let resultPath = path?.appending("/" + subPath)
                        let model = WXXFileListModel()
                        model.filePath = resultPath!
                        fileListArray.append(model)
                    }
                }
            } catch _ {}
        }
        
      return fileListArray
    }
    
    class func rootPath() -> String {
        return NSHomeDirectory()
    }
    
    class func removeFileAtPath(path: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
            } catch _ {}
        }
    }
}
