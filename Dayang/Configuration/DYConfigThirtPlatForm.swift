//
//  DYConfigThirtPlatForm.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import Foundation
import Bugly
public class DYConfigThirtPlatForm {
    
    public class func configTPF() {
        configBugly()
        DYLocalFilePathServer.checkLocalPath()
        DYRealmDBServer.configDB()
        dy_Print(DYLocalFilePathServer.userRootPath())
    }
    
    /// 启动bugly
    fileprivate class func configBugly() {
        let config = BuglyConfig()
        let version = UIDeviceHardware.appVersion()
        config.version = version
        #if DEBUG
            config.channel = "Debug"
            config.debugMode = true
        #else
            config.channel = "Realease"
            config.debugMode = false
        #endif
        config.reportLogLevel = BuglyLogLevel.error
        config.unexpectedTerminatingDetectionEnable = true
        Bugly.start(withAppId: kBuglyAppId, config: config)
    }

}
