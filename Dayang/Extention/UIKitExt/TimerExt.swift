//
//  TimerExt.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/25.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import Foundation

extension Timer {
    
    public class func dy_scheduledTimer(timeInterval ti: TimeInterval, repeats yesOrNo: Bool, block:(()->())) -> Timer {
     
        let timer = self.scheduledTimer(timeInterval: ti, target: self, selector:#selector(timerAction) , userInfo: block, repeats: yesOrNo)
        RunLoop.current.add(timer, forMode: .commonModes)
        return timer
        
    }

  @objc private class func timerAction(timer: Timer) {
        let block = (timer.userInfo as? (()->()))
        if block != nil {
            block!()
        }
    }
}
