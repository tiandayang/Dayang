//
//  DYHomeModel.swift
//  Dayang
//
//  Created by 田向阳 on 2018/1/3.
//  Copyright © 2018年 田向阳. All rights reserved.
//

import UIKit

class DYHomeModel: NSObject {
    
    public class func getHomePageRequest(complete: DYRequestCompleteBlock?) {
        DYNetWorkServer.post(path: "homeList", module: .home, params: nil, isCache: true, complete: complete)
    }
}
