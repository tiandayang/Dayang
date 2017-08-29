//
//  DYActionSheetHelper.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYActionSheetHelper {
    /// 展示actionSheet
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - items: 按钮标题的集合
    ///   - controller: 当前VC
    ///   - complete: 点击回调
    public class func showActionSheet(title: String?, items: [String]?, cancelTitle: String, controller: UIViewController, complete: alertClickBlock?) {
        
        let actionSheetController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        if items != nil && items?.count != 0 {
            for itemTitle in items! {
                let action = UIAlertAction.init(title: itemTitle, style: .default, handler: { (action) in
                    if complete != nil {
                        complete!((items?.index(of: itemTitle))! + 1)
                    }
                })
                actionSheetController.addAction(action)
            }
        }
        let action = UIAlertAction.init(title: cancelTitle, style: .cancel, handler: { (action) in
            if complete != nil {
                complete!(0)
            }
        })
        actionSheetController.addAction(action)
        controller.present(actionSheetController, animated: true, completion: nil)
    }
    

}
