//
//  DYHomeModel.swift
//  Dayang
//
//  Created by 田向阳 on 2018/1/3.
//  Copyright © 2018年 田向阳. All rights reserved.
//

import UIKit
import HandyJSON
import RealmSwift

class DYHomeModel: DYBaseModel {
    
    var banner:[DYBannerModel]?
    var code: String?
    var msg: String?
    
    public class func getHomePageRequest(complete: ((_ error: NSError,_ homeModel: DYHomeModel?)->(Void))?) {
        
        DYNetWorkServer.post(path: "/homeList", module: .home, params: nil, isCache: true) { (error, data ,result) -> (Void) in
            guard complete != nil else{
                return;
            }
            DispatchQueue.global().async {
                if (error.code == errorCode.success.rawValue || error.code == errorCode.cache.rawValue)  && data != nil {
                    let model = JSONDeserializer<DYHomeModel>.deserializeFrom(dict: result! as NSDictionary)
                    dy_safeAsync {
                        complete!(error,model)
                    }
                }else{
                    dy_safeAsync {
                        complete!(error,nil)
                    }
                }
            }
        }
    }
    //这个是因为realm数据库不支持 [DYBannerModel]类型的属性 故将此拉入黑名单  回头寻找更好的解决方案
    override static func ignoredProperties() -> [String] {
        return ["banner"]
    }
    
}
