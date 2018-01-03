//
//  DYHUDHelper.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/1.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import PKHUD

class DYHUDHelper {

    /// 展示一个 提示成功或者失败的hud
    ///
    /// - Parameters:
    ///   - inView: 展示的view
    ///   - title: 显示的文字
    ///   - isSuccess: 是成功的还是失败的
    public class func showSuccessHUD(inView: UIView, title: String?, isSuccess: Bool){
        if isSuccess {
            showHUD(inView: inView, content: .labeledSuccess(title: nil, subtitle: title), complete: nil)
        }else{
            showHUD(inView: inView, content: .labeledError(title: nil, subtitle: title), complete: nil)
        }
    }

    /// 展示一个纯文本的hud
    ///
    /// - Parameters:
    ///   - inView: 父视图
    ///   - title: 文本内容
    public class func showHUD(inView: UIView, title: String?) {
        showHUD(inView: inView, content: .label(title), complete: nil)
    }
    
    /// 展示一个带图片的hud
    ///
    /// - Parameters:
    ///   - inView: 父视图
    ///   - image: 图片
    ///   - title: 标题
    public class func showHUD(inView: UIView, image: UIImage?, title: String?) {
        showHUD(inView: inView, content: .labeledImage(image: image, title: nil, subtitle: title), complete: nil)
    }
    
    /// 展示一个不停留的hud
    ///
    /// - Parameters:
    ///   - inView: 展示的父视图
    ///   - content: hud的contentType
    ///   - complete: 结束后的回调
    public class func showHUD(inView: UIView,content: HUDContentType, complete: ((_ finish: Bool) -> Void)?) {
        HUD.flash(content, onView: inView, delay: 1.5, completion: complete)
    }
    
    public class func showProgressHUD(inView: UIView, progress: Float) {
        
    }
}
