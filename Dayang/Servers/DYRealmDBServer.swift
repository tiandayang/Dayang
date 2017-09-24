//
//  DYRealmDBServer.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/22.
//  Copyright © 2017年 田向阳. All rights reserved.
//
import RealmSwift

class DYRealmDBServer: NSObject {
    
    /// 版本迁移配置
    public class func configDB() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
    }
}
