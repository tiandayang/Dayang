//
//  DYProgressView.swift
//  DYProgressView
//
//  Created by 田向阳 on 2017/9/22.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let progressWidth = CGFloat(40);
private let stateWidth = CGFloat(30);

class DYProgressView: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: public
    public func setStateLayer(image: UIImage) {
        let cgImage = image.cgImage;
        stateLayer.contents = cgImage;
        stateLayer.opacity = 1
        progressLayer.opacity = 0;
        progressLabel.isHidden = true
    }
    
    //MARK: CreateUI
   private func createUI() {
    backgroundColor = .clear
    addSubview(progressLabel)
    layer.addSublayer(stateLayer)
    stateLayer.opacity = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLabel.frame = CGRect.init(x: (self.frame.size.width - progressWidth)/2.0, y: (self.frame.size.height - 20)/2.0, width: progressWidth, height: 20)
        stateLayer.frame = CGRect.init(x: (self.frame.size.width - stateWidth)/2.0, y: (self.frame.size.height - stateWidth)/2.0, width: stateWidth, height: stateWidth)

    }
    
    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    lazy var stateLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        return label
    }()
    
    var progress: Double = 0.0 {
        didSet{
            progressLayer.strokeEnd = CGFloat(progress);
            progressLabel.text = String(format: "%.1f%%", progress * 100.0)
            stateLayer.opacity = 0
            progressLayer.opacity = 1
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        progressLayer.frame = CGRect(x:(rect.size.width - progressWidth)/2.0,y:(rect.size.height - progressWidth)/2.0,width: progressWidth,height: progressWidth)
        progressLayer.cornerRadius = progressWidth/2.0
        progressLayer.backgroundColor = UIColor.clear.cgColor
        let path = UIBezierPath.init(roundedRect: progressLayer.bounds.insetBy(dx: 1, dy: 1), cornerRadius: (progressWidth / 2 - 1))
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = 2
        progressLayer.lineCap = kCALineCapRound
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0;
        layer.addSublayer(progressLayer)
    }
}
