//
//  DYPhotoPreViewImageCell.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/30.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYPhotoPreViewImageCell: DYPhotoPreviewBaseCell {
    
    override func createUI() {
        super.createUI()
        contentView.addSubview(scrollView)
        scrollView.addSubview(zoomView)
        
        imageView = UIImageView()
        imageView?.clipsToBounds = true
        imageView?.isUserInteractionEnabled = true
        zoomView.addSubview(imageView!)
    }
    //MARK:Action
    override func setPhotoModel() {
        requestImage()
    }
    
    //获取图片
    public func requestImage() {
        self.imageView?.image = photoModel?.thumbImage
        if photoModel?.image != nil {
            self.imageView?.image = photoModel?.image
            resizeImageView()
        }else if(photoModel?.asset != nil) {
            DYPhotosHelper.requestImage(asset: (photoModel?.asset)!, isOrigin: false, complete: { (image) in
                self.imageView?.image = image
                self.photoModel?.image = image
                self.resizeImageView()
            })
        }else if (photoModel?.imageURL != nil) {
            self.imageView?.kf.setImage(with:  URL.init(string: (photoModel?.imageURL)!), placeholder: nil, options:nil, progressBlock: { (receiveSize, totalSize) in
                //                    let progress = Float(receiveSize/totalSize)
                
            }, completionHandler: { (image, error, cacheType, url) in
                self.photoModel?.image = image
                self.imageView?.image = image
                self.resizeImageView()
            })
        }else if (photoModel?.imagePath != nil ) {
            do {
                let data = try Data.init(contentsOf: URL.init(fileURLWithPath: (photoModel?.imagePath)!))
                let image = UIImage.init(data: data)
                imageView?.image = image
                photoModel?.image = image
                self.resizeImageView()
            } catch _ {}
        }
    }
    
    private func resizeImageView() {
        if self.imageView?.image == nil {
            return
        }
        scrollView.setZoomScale(1, animated: true)
        scrollView.frame = self.bounds
        zoomView.frame = scrollView.bounds
        let imageSize = self.imageView?.image?.size
        let scale = (imageSize?.width)!/(imageSize?.height)!
        let width = zoomView.mj_w
        let height = width / scale
        imageView?.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        zoomView.bounds = (imageView?.bounds)!
        
    }
    
    override func doubleTapAction(doubleTap: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1 {
            scrollView.setZoomScale(1, animated: true)
        }else{
            let touchPoint = doubleTap.location(in: self.imageView!)
            let width = self.mj_w / scrollView.maximumZoomScale
            let height = self.mj_y / scrollView.maximumZoomScale
            scrollView.zoom(to: CGRect.init(x: touchPoint.x - width/2, y: touchPoint.y - height/2, width: width, height: height), animated: true)
        }
        
    }
    
    //MARK:CreateUI
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.maximumZoomScale = 2
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.minimumZoomScale = 1.0;
        scrollView.delegate = self;
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.clipsToBounds = true;
        return scrollView
    }()
    
    fileprivate lazy var zoomView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
}

extension DYPhotoPreViewImageCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.mj_w > scrollView.contentSize.width) ? (scrollView.mj_w - scrollView.contentSize.width) * 0.5 : 0
        
        let offsetY = (scrollView.mj_h > scrollView.contentSize.height) ? (scrollView.mj_h - scrollView.contentSize.height) * 0.5 : 0
        zoomView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
}
