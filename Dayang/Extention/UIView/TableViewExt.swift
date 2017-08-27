//
//  TableViewExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {

    public func dy_addHeaderFooterRefresh(target: Any,headerSelector: Selector?, footerSelector: Selector?) {
        if headerSelector != nil {
            self.mj_header = MJRefreshNormalHeader.init(refreshingTarget: target, refreshingAction: headerSelector)
        }
        if footerSelector != nil {
            self.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: target, refreshingAction: footerSelector)
        }
    }
}
