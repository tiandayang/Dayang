//
//  DYApiConfig.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/21.
//  Copyright © 2017年 田向阳. All rights reserved.
//

public let currentNetworkEnvironment = DYNetworkEnvironmentType.local

public enum DYNetworkEnvironmentType: String{
    case local = "local"  //本地环境
    case develop = "develop" //开发环境
    case product = "product" //线上环境
}

/// 不同模块的域名前缀  可根据不同业务结构进行调整
public enum DYNetworkModuleBaseURL: String{
    case home = "home"
    case person = "person"
    
    func resultURL() -> String {
        switch currentNetworkEnvironment {
        case .local:
            switch self {
            case .home:
                return "http://192.168.0.100:4000"
            case .person:
                return "http://192.168.0.100:4000"
            }
        case .develop:
            switch self {
            case .home:
                return "http://www.developDyHome.com"
            case .person:
                return "http://www.developDyPerson.com"
            }
        case .product:
            switch self {
            case .home:
                return "http://www.dyHome.com"
            case .person:
                return "http://www.dyPerson.com"
            }
        }
    }
}

public func makeUpURL(urlType: DYNetworkModuleBaseURL, path: String) -> String{
    return urlType.resultURL() + path
}

