//
//  DYNetCache.swift
//  Dayang
//
//  Created by 田向阳 on 2018/1/3.
//  Copyright © 2018年 田向阳. All rights reserved.
//

import UIKit

class DYNetCache {
    public class func store(request: DYBaseRequest, data: Data) {
        DYCache.shared.store(obj: data, key: getCacheKey(request: request))
    }
    
    public class func getCache(request: DYBaseRequest, complete: DYRequestCompleteBlock?) {
        DYCache.shared.getObject(key: getCacheKey(request: request)) { (data) -> (Void) in
            guard data != nil else {
                return
            }
            do {
                if let dict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any] {
                    let error = NSError.init(domain: DYNetworkDomain, code: errorCode.cache.rawValue, userInfo: nil)
                    dy_safeAsync {
                        complete?(error, dict)
                    }
                }
            } catch {}
        }
    }
    
    fileprivate class func getCacheKey(request: DYBaseRequest) -> String {
        let params = request.params ?? [:]
        return "method:\(request.method.rawValue) url:\(request.url) Argument:\(params)" .md5()
    }
}
