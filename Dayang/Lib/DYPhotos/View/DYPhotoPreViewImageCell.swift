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
        contentView.addSubview(activity)
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
            self.imageView?.kf.setImage(with:  URL.init(string: (photoModel?.imageURL)!), placeholder: #imageLiteral(resourceName: "photo_PlaceHolder.png"), options:nil, progressBlock: { [weak self] (receiveSize, totalSize) in
                // let progress = Float(receiveSize/totalSize)
                if !(self?.activity.isAnimating)! {
                    self?.activity.startAnimating()
                }
                
                }, completionHandler: { [weak self]  (image, error, cacheType, url) in
                    if error == nil {
                        self?.photoModel?.image = image
                        self?.imageView?.image = image
                    }else{
                        self?.imageView?.image = #imageLiteral(resourceName: "photo_PlaceHolder.png")
                    }
                    self?.activity.stopAnimating()
                    self?.resizeImageView()
            })
        }else if (photoModel?.imagePath != nil ) {
            autoreleasepool{
                do {
                    let data = try Data.init(contentsOf: URL.init(fileURLWithPath: (photoModel?.imagePath)!))
                    let image = UIImage.init(data: data)
                    imageView?.image = image
                    photoModel?.image = image
                    self.resizeImageView()
                } catch _ {}
            }
        }
    }
    
    private func resizeImageView() {
        if self.imageView?.image == nil {
            return
        }
        scrollView.maximumZoomScale = 2
        scrollView.frame = self.bounds
        zoomView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        let imageSize = self.imageView?.image?.size ?? CGSize.zero
        let scale = imageSize.width/imageSize.height
        let width = zoomView.frame.size.width
        let height = width / scale
        imageView?.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        zoomView.bounds = (imageView?.bounds)!
        scrollView.setZoomScale(1.1, animated: false)
        self.scrollView.setZoomScale(1, animated: false)
        scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func doubleTapAction(doubleTap: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1 {
            scrollView.setZoomScale(1, animated: true)
        }else{
            let touchPoint = doubleTap.location(in: self.imageView!)
            let width = self.bounds.size.width / scrollView.maximumZoomScale
            let height = self.frame.origin.y / scrollView.maximumZoomScale
            scrollView.zoom(to: CGRect.init(x: touchPoint.x - width/2, y: touchPoint.y - height/2, width: width, height: height), animated: true)
        }
        
    }
    
    //MARK:CreateUI
    lazy var scrollView: DYScrollView = {
        let scrollView = DYScrollView(frame: self.bounds)
        scrollView.maximumZoomScale = 2
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.minimumZoomScale = 1.0;
        scrollView.delegate = self;
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.clipsToBounds = true;
        return scrollView
    }()
    
    fileprivate lazy var zoomView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var activity: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(frame: self.bounds)
        act.activityIndicatorViewStyle = .white
        return act
    }()
}

extension DYPhotoPreViewImageCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0
        
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0
        zoomView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
}

class  DYScrollView: UIScrollView, UIGestureRecognizerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let view = otherGestureRecognizer.view {
            if view.isKind(of: UIScrollView.classForCoder()) {
                if otherGestureRecognizer != self.panGestureRecognizer {
                    // collectionView的pan
                    if (self.contentOffset.x == 0 || self.contentOffset.x == self.contentSize.width - self.frame.size.width)  && self.zoomScale == 1 && !self.isDragging{
                        return true
                    }
                    return false
                }else{
                    //当前的scrollView
                    if self.contentOffset.y == 0 || self.contentOffset.x == 0 || self.contentOffset.y == self.contentSize.height - self.frame.size.height || self.contentOffset.x == self.contentSize.width - self.frame.size.width {
                        return false
                    }
                    return true
                }
            }else{
                //预览界面的手势
                if self.contentOffset.y == 0 && self.zoomScale == 1  && !self.isDragging{
                    return true
                }
                return false
            }
        }
        return true
    }
}
