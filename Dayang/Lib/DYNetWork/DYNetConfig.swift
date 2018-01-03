//
//  DYNetConfig.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/21.
//  Copyright © 2017年 田向阳. All rights reserved.
//

public enum DYRequestMethod: String {
    case post = "POST"
    case get = "GET"
}

public enum errorCode: Int {
    case success = 200  //请求成功
    case cache = 10086 //从缓存中读取
    case serverError = 500 //服务器内部错误
    case netError = -999 //网络错误
    case timeOut = 408  //请求超时
    
    // 业务的错误码 举个🌰
    case loginFaild = 9000 //登录失败
}

typealias DYRequestCompleteBlock = (_ error: NSError, _ result: [String:Any]?) -> (Void)
