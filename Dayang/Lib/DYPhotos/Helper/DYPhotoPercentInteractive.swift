//
//  DYPercentDrivenInteractive.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/12.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

class DYPhotoPercentInteractive: UIPercentDrivenInteractiveTransition {
    
    var panGesture: UIPanGestureRecognizer!
    var transitionContext: UIViewControllerContextTransitioning!
    var isFirst: Bool = true
    var bgView = UIView()
    var imageView = UIImageView()
    fileprivate var originCenter = CGPoint.zero
    fileprivate var startPoint = CGPoint.zero
    
    convenience init(gesture: UIPanGestureRecognizer) {
        self.init()
        self.panGesture = gesture
        self.panGesture.addTarget(self, action: #selector(gestureChanged))
        bgView.backgroundColor = UIColor.black
    }
    
    deinit {
        self.panGesture.removeTarget(self, action: #selector(gestureChanged))
    }
    
    @objc func gestureChanged(sender: UIPanGestureRecognizer) {
        
        let scale = getTranslationScale()
        if isFirst && transitionContext != nil {
            beginInterPercent()
            isFirst = false
            originCenter = imageView.center
            startPoint = sender.translation(in: sender.view)
        }
        
        switch sender.state {
        case .began:
            break
        case.possible:
            break
        case.changed:
            update(scale)
            updateInterPercent(scale: scale)
            var translation = sender.translation(in: sender.view)
            if translation.y < 0 {
                translation.y = 0
            }
            if imageView.frame.size.height > WINDOW_HEIGHT {
                imageView.center = CGPoint(x: self.originCenter.x + translation.x, y: self.originCenter.y - translation.y )
            }else{
                imageView.center = CGPoint(x: self.originCenter.x + translation.x, y: self.originCenter.y + translation.y )
            }
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            break
        default:
            if scale > 0.8 {
                cancel()
                interPercentCancel()
            }else{
                finish()
                funcinterPercentFinish(scale: scale)
            }
            break
        }
    }
    
    func beginInterPercent() {
        if transitionContext == nil {
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(bgView)
        bgView.frame = transitionContext.containerView.bounds;
        
        let fromVC = transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
        fromVC.view.isHidden = true
        
        let cell = fromVC.collectionView.visibleCells.first as! DYPhotoPreviewBaseCell
        if cell.isKind(of: DYPhotoPreViewImageCell.classForCoder()) {
            let imageCell = cell as! DYPhotoPreViewImageCell
            imageCell.scrollView.isScrollEnabled = false
        }
        imageView.image = cell.imageView?.image ?? UIImage(named: "photo_PlaceHolder")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        //        var frame = UIImage.scaleImageFrame(image: imageView.image!)
        //        frame.size.height = frame.size.height > WINDOW_HEIGHT ? WINDOW_HEIGHT :  frame.size.height
        imageView.frame = UIImage.scaleImageFrame(image: imageView.image!)
        containerView.addSubview(imageView)
    }
    
    func interPercentCancel() {
        if transitionContext == nil {
            return
        }
        let fromVC = transitionContext.viewController(forKey: .from)
        let containerView = transitionContext.containerView
        fromVC?.view.isHidden = false
        containerView.addSubview((fromVC?.view)!);
        self.imageView.removeFromSuperview()
        self.bgView.removeFromSuperview()
        isFirst = true
        let photoVC = fromVC as! DYPhotoPreviewController
        let cell = photoVC.collectionView.visibleCells.first as! DYPhotoPreviewBaseCell
        if cell.isKind(of: DYPhotoPreViewImageCell.classForCoder()) {
            let imageCell = cell as! DYPhotoPreViewImageCell
            imageCell.scrollView.isScrollEnabled = true
        }
        self.transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    func updateInterPercent(scale: CGFloat) {
        if transitionContext == nil {
            return
        }
        self.bgView.alpha = scale
    }
    
    
    func funcinterPercentFinish(scale: CGFloat) {
        if transitionContext == nil {
            return
        }
        let fromVC = transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
        let endFrame = fromVC.thumbTapView?.superview?.convert((fromVC.thumbTapView?.frame)!, to:((UIApplication.shared.delegate?.window)!)!)
        if endFrame != nil && UIScreen.main.bounds.contains(endFrame!){
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveLinear, animations: {
                self.imageView.frame = endFrame!
                self.bgView.alpha = 0
            }) { (finish) in
                self.imageView.removeFromSuperview()
                self.bgView.removeFromSuperview()
                self.isFirst = true
                self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
                let fromVC = self.transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
                let cell = fromVC.collectionView.visibleCells.first as! DYPhotoPreviewBaseCell
                if cell.isKind(of: DYPhotoPreViewImageCell.classForCoder()) {
                    let imageCell = cell as! DYPhotoPreViewImageCell
                    imageCell.scrollView.isScrollEnabled = false
                }
            }
        }else{
            //            UIView.animate(withDuration: 0.25, animations: {
            //                self.transitionContext.containerView.alpha = 0
            //                self.transitionContext.containerView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            //            }, completion: { (finish) in
            //                self.imageView.removeFromSuperview()
            //                self.bgView.removeFromSuperview()
            //                self.isFirst = true
            //                self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
            //            });
            let endFrame = CGRect(x: 0, y: imageView.bounds.size.height + UIScreen.main.bounds.size.height, width: imageView.bounds.size.width, height: imageView.bounds.size.height)
            UIView.animate(withDuration: 0.25, animations: {
                self.imageView.frame = endFrame
                self.bgView.alpha = 0
            }) { (finish) in
                self.imageView.removeFromSuperview()
                self.bgView.removeFromSuperview()
                self.isFirst = true
                self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
                let fromVC = self.transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
                let cell = fromVC.collectionView.visibleCells.first as! DYPhotoPreviewBaseCell
                if cell.isKind(of: DYPhotoPreViewImageCell.classForCoder()) {
                    let imageCell = cell as! DYPhotoPreViewImageCell
                    imageCell.scrollView.isScrollEnabled = false
                }
            }
        }
        
    }
    
    //MARK:Helper
    func getTranslationScale() -> CGFloat {
        let translation = self.panGesture.translation(in: self.panGesture.view)
        var scale = 1 - (translation.y / (self.panGesture.view?.frame.size.height)!)
        scale = scale < 0 ? 0 : scale
        return scale > 1 ? 1 : scale
    }
    //MARK:UIViewControllerInteractiveTransitioning
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
    
}
