//
//  DYPersonUIModel.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit


class DYPersonUIModel: DYBaseModel {

    var icon: String?
    var title: String?
    
    public class func getAllList(complete: ((_ array: [DYPersonUIModel])->())?) {
        var listArray = [DYPersonUIModel]()
        for title in nameArray() {
            let model = DYPersonUIModel()
            model.title = title;
            let index = nameArray().index(of: title)
            model.icon = imgArray().dy_objectAtIndex(index: index ?? 0)
            listArray.append(model)
        }
        if complete != nil {
            complete!(listArray)
        }
    }
    private class func nameArray() -> Array<String> {
        let array = ["本地文件","我的视频","我的照片","其他文件"]
        return array
    }
    
    private class func imgArray() -> Array<String> {
        let array = ["file_folder","file_video","file_image","file_other"]
        return array
    }
}
