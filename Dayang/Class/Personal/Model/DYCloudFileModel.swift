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
                "http://lavaweb-10015286.video.myqcloud.com/%E5%B0%BD%E6%83%85LAVA.mp4",
                "http://lavaweb-10015286.video.myqcloud.com/lava-guitar-creation-2.mp4",
                "http://lavaweb-10015286.video.myqcloud.com/hong-song-mei-gui-mu-2.mp4",
                "http://lavaweb-10015286.video.myqcloud.com/ideal-pick-2.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_01.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_02.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_03.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_04.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_05.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_06.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_07.mp4",
                "http://120.25.226.186:32812/resources/videos/minion_08.mp4",
                ]
    }
}
