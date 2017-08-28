//
//  DYKeychainServer.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import KeychainAccess

private let kService = "com.wxx.dayang"
private let kAccount = "com.dayang.deviceid"
    
class DYKeychainServer {
        //MARK: public func
        public class func getDeviveID() -> String {
            if let deviceId = getDeviceIdFromSandBox() {
                return deviceId
            }
            if let deviceId = getDeviceIdFromKeychain() {
                return deviceId
            }
            return storeDeviceIdToKeychain()
        }
        
        //MARK: fileprivate func
        fileprivate class func storeDeviceIdToKeychain () -> String {
            let keychain = Keychain(service: kService)
            let deviceID = NSUUID().uuidString
            keychain[kAccount] = deviceID
            storeDeviceIdToSandbox(deviceID: deviceID)
            return deviceID
        }
        
        fileprivate class func storeDeviceIdToSandbox(deviceID: String) {
            UserDefaults.standard.setValue(deviceID, forKey: kAccount)
            UserDefaults.standard.synchronize()
        }
        
        fileprivate class func getDeviceIdFromKeychain()  -> String? {
            let items = Keychain(service: kService).allItems()
            let item = items.first
            if let deviceId = item?["value"] as? String{
                storeDeviceIdToSandbox(deviceID: deviceId)
                return deviceId;
            }
            return nil
        }
        
        fileprivate class func getDeviceIdFromSandBox()  -> String? {
            return UserDefaults.standard.string(forKey: kAccount)
        }
}

