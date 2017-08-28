//
//  DYLocalFilePathServer.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let kDocument = "Documents"
private let kLibrary = "Library"
private let kImages = "Image"
private let kVideos = "video"
private let kOthers = "others"

class DYLocalFilePathServer {

    
    public class func checkLocalPath() {
        let fileManager = FileManager.default
        let pathArray = [imagePath(), videoPath(), otherPath()]
        for path in pathArray {
            if !fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                } catch _ {}
            }
        }
    }
    
    public class func userRootPath()-> String {
        let deviceId = DYKeychainServer.getDeviveID()
       return NSHomeDirectory() + "/Documents/" + deviceId
    }
    
    public class func imagePath() -> String {
        return userRootPath().appending("/") + kImages
    }
    
    public class func videoPath() -> String {
        return userRootPath().appending("/") + kVideos
    }
    
    public class func otherPath() -> String {
        return userRootPath().appending("/") + kOthers
    }
}
