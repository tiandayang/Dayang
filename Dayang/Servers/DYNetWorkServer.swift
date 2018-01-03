//
//  DYNetWorkServer.swift
//  Dayang
//
//  Created by 田向阳 on 2018/1/3.
//  Copyright © 2018年 田向阳. All rights reserved.
//

import UIKit

class DYNetWorkServer {
    
    public class func post(path: String, module:DYNetworkModuleBaseURL, params: Dictionary<String, Any>?, isCache: Bool, complete: DYRequestCompleteBlock?) {
        let url = makeUpURL(urlType: module, path: path)
        DYNetworkManager.shared.dyPost(url: url, params: params, isCache: isCache, complete: complete)
    }
    
    public class func get(path: String, module:DYNetworkModuleBaseURL, isCache: Bool, complete: DYRequestCompleteBlock?){
         let url = makeUpURL(urlType: module, path: path)
        DYNetworkManager.shared.dyGet(url: url, isCache: isCache, complete: complete)
    }
    
}
