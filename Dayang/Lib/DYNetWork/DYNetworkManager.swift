//
//  DYNetworkManager.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/27.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import Alamofire

let DYNetworkDomain = "dyNetWorkDoMain"

public class DYNetworkManager: NSObject {
    
    public static let shared = DYNetworkManager()
    var httpHeader: Dictionary<String, String>!
    lazy var httpManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15;  //设置网络请求最大时长
        return SessionManager(configuration:config)
    }()
    
    override init() {
        var header: [String: String] = [:]
        header["alias"] = UIDevice.dy_deviceAlias()
        header["OSPlatform"] = "iOS"
        header["deviceName"] = UIDeviceHardware.platformString()
        header["systemVersion"] = UIDevice.current.systemVersion
        header["appVersion"] = UIDeviceHardware.appVersion()
        header["deviceId"] = DYKeychainServer.getDeviveID()
        httpHeader = header
    }
    
    func dyGet(url: String, isCache: Bool = false, complete: DYRequestCompleteBlock?) {
        let request = DYBaseRequest()
        request.url = url
        request.method = .get
        request.isCache = isCache
        dyRequest(request: request, complete: complete)
    }
        
    func dyPost(url:String, params: Dictionary<String, Any>?,isCache: Bool = false,complete: DYRequestCompleteBlock?) {
        let request = DYBaseRequest()
        request.url = url
        request.params = params
        request.isCache = isCache
        dyRequest(request: request, complete: complete)
    }
    
    func dyRequest(request: DYBaseRequest,complete: DYRequestCompleteBlock?){
        if request.isCache {
            DYNetCache.getCache(request: request, complete: complete)
        }
        let method = HTTPMethod(rawValue: request.method.rawValue)!
        self.httpManager.request(request.url, method: method, parameters: request.params, encoding: JSONEncoding.default, headers: httpHeader).responseData(completionHandler: { (response) in
            DispatchQueue.global().async {
                if response.data == nil || response.data?.count == 0{
                    var error = response.error
                    if error == nil {
                        error = NSError.init(domain: DYNetworkDomain, code: errorCode.netError.rawValue, userInfo: nil)
                    }
                    dy_safeAsync {
                        complete?(error! as NSError, nil)
                    }
                    dy_Print("\n error:\(String(describing: response.error))\n header:\(self.httpHeader)\n params:\(request.params ?? [:])")
                    return
                }
                
                do {
                    if let dict = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String : Any] {
                        let code = dict["code"] as! Int  // 根据自己接口结构而定
                        // let code = (response.error as NSError?)?.code ?? 200
                        let error = NSError(domain: DYNetworkDomain, code: code, userInfo: nil)
                        dy_safeAsync {
                            complete?(error, dict)
                        }
                        if request.isCache {
                            DYNetCache.store(request: request, data: response.data!)
                        }
                        dy_Print("\n params:\(request.params ?? [:]) \n response:\(dict)\n header:\(self.httpHeader)")
                    }
                    
                } catch {
                    var error = response.error
                    if error == nil {
                        error = NSError.init(domain: DYNetworkDomain, code: errorCode.serverError.rawValue, userInfo: nil)
                    }
                    dy_safeAsync {
                        complete?(error! as NSError, nil)
                    }
                }
            }
        })
    }
}
