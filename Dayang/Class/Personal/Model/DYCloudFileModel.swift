//
//  DYCloudFileModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/6.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYCloudFileModel: DYDownloadFileModel {
    public class func getCloudFileList(complete:((_ listArray: Array<DYCloudFileModel>) -> Void)?) {
        if complete == nil {
            return
        }
        var listArray = Array<DYCloudFileModel>()
        for url in getFileURL() {
            let model = DYCloudFileModel()
            model.fileUrlString = url 
            listArray.append(model)
        }
        complete!(listArray)
    }
    
    private class func getFileURL() -> Array<String> {
        return ["http://metalk-5-cn.oss-cn-beijing.aliyuncs.com/ufile%2F280b723919a680abf16b99d70df07fdb%2F0EF8093F-C65C-4BC7-95E6-49C58EE6D15E.mp4",
                "http://metalk-5-cn.oss-cn-beijing.aliyuncs.com/ufile/7c0b181e1d05a6240d5f9bae2fdc4b1c.png",
                "http://metalk-5-cn.oss-cn-beijing.aliyuncs.com/ufile%2Ff452b016e3858550f3390abb2d1241e9%2F658031A3-5D73-48DF-B548-5EBAA8E457AC.png",
                "http://metalk-5-cn.oss-cn-beijing.aliyuncs.com/chat/93fc2c8f5529d5d13c1af20402032347.jpg",
                "https://metalk-5-development.s3-accelerate.amazonaws.com/pan/280b723919a680abf16b99d70df07fdb/5B416C59-DCB6-4EFF-AF34-C64FC5D72BA0.zip",
                ]
    }
}
