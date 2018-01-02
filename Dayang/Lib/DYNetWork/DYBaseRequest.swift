//
//  DYBaseRequest.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/27.
//  Copyright © 2017年 田向阳. All rights reserved.
//
import UIKit

class DYBaseRequest {
    var url: String!//请求地址
    var timeOut: TimeInterval = 30.0 //请求时长
    var params: Dictionary<String, Any>? //请求参数
    var method: DYRequestMethod = .post   //请求方式  post or get
    var isCache: Bool = false  //是否缓存
    
}
