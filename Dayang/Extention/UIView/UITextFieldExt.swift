//
//  UITextFieldExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/29.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

extension UITextField {
    
    func textChangeBlock(change: ((_ text: String)->())?) {
        self.reactive.controlEvents(.allEditingEvents).observeValues { (textField) in
            if change != nil {
                change!(textField.text!)
            }
        }
    }
}
