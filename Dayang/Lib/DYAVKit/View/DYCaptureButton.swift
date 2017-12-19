//
//  DYCaptureButton.swift
//  DYCaptureButton
//
//  Created by 田向阳 on 2017/11/28.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

let lineWidth = CGFloat(4)
let cb_animationDuration = 0.18

@objc protocol DYCaptureButtonDelegate: NSObjectProtocol {
    @objc optional func dy_takePhotoAction()
    @objc optional func dy_beginRecord()
    @objc optional func dy_endRecord()
}

class DYCaptureButton: UIView {
    //Properties
    var  bgLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    weak var delegate: DYCaptureButtonDelegate?
    //MARK: lifeCircle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI(frame: frame)
        addObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:Action
    var progress: Double = 0 {
        didSet{
            if progress >= 1.0 {
                buttonTouchCancel()
            }else{
                progressLayer.strokeEnd = CGFloat(progress)
            }
        }
    }
    
    @objc private func buttonTouchUpInside(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            touchAnimation(complete: { [weak self] in
               self?.cancelAnimation()
            })
            let selector = #selector(DYCaptureButtonDelegate.dy_takePhotoAction)
            if delegate != nil && (delegate?.responds(to: selector))!{
                delegate?.dy_takePhotoAction!()
            }
            break
        default:break
        }
    }
    
    @objc private func buttonTouchCancel() {
        cancelAnimation()
        let selector = #selector(DYCaptureButtonDelegate.dy_endRecord)
        if delegate != nil  && (delegate?.responds(to: selector))!{
            delegate?.dy_endRecord!()
        }
    }
    
    @objc private func buttonTouchDown(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            touchAnimation(complete: nil)
            let selector = #selector(DYCaptureButtonDelegate.dy_beginRecord)
            if delegate != nil  && (delegate?.responds(to: selector))!{
                delegate?.dy_beginRecord!()
            }
            break
        case .ended:
            buttonTouchCancel()
            break
        case .cancelled:
            buttonTouchCancel()
            break
        default:
            break
        }
    }
    
    //MARK:Observer
    private func addObserver() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(buttonTouchUpInside));
        self.addGestureRecognizer(tap)
        
        let longpress = UILongPressGestureRecognizer.init(target: self, action: #selector(buttonTouchDown))
        longpress.minimumPressDuration = animationDuration;
        self.addGestureRecognizer(longpress)
    }
    
    //MARK: createUI
    override func layoutSubviews() {
        bgLayer.frame = self.bounds
        progressLayer.frame = self.bounds
    }
    
    private func createUI(frame: CGRect) {
        let roundRadius = frame.size.width * 0.5;
        let rect = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        let circlePath = UIBezierPath.init(roundedRect: rect.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius:roundRadius)
        bgLayer = createLayer(path: circlePath)
        bgLayer.strokeColor = UIColor.white.cgColor
        progressLayer = createLayer(path: circlePath)
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.strokeEnd = 0;
        self.layer.addSublayer(bgLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func createLayer(path: UIBezierPath) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        layer.lineCap = kCALineCapRound
        layer.lineWidth = lineWidth
        return layer
    }
    
    private func touchAnimation(complete:(() ->())?) {
        UIView.animate(withDuration: cb_animationDuration, animations: {
            self.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }) { (finish) in
            if complete != nil {
                complete!()
            }
        }
    }
    
    private func cancelAnimation() {
        UIView.animate(withDuration: cb_animationDuration) {
            self.transform = CGAffineTransform.identity
        }
    }
}
