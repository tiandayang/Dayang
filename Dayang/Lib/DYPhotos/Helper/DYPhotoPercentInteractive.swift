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
    fileprivate var originCenter: CGPoint!
    
    convenience init(gesture: UIPanGestureRecognizer) {
        self.init()
        self.panGesture = gesture
        self.panGesture.addTarget(self, action: #selector(gestureChanged))
        bgView.backgroundColor = UIColor.black
        let size = UIScreen.main.bounds.size
        originCenter = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
    }
    
    deinit {
        self.panGesture.removeTarget(self, action: #selector(gestureChanged))
    }
        
    func gestureChanged(sender: UIPanGestureRecognizer) {
        
        let scale = getTranslationScale()
        if isFirst && transitionContext != nil {
            beginInterPercent()
            isFirst = false
        }
        
        switch sender.state {
        case .began:
            break
        case.possible:
            break
        case.changed:
            update(scale)
            updateInterPercent(scale: scale)
             let translation = sender.translation(in: sender.view)
            imageView.center = CGPoint(x: self.originCenter.x + translation.x * scale, y: self.originCenter.y + translation.y)
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
        imageView.image = cell.imageView?.image ?? UIImage(named: "photo_PlaceHolder")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
//        let endFrame = CGRect.init(x: 0, y: imageView.bounds.size.height + UIScreen.main.bounds.size.height, width: imageView.bounds.size.width, height: imageView.bounds.size.height)
//        UIView.animate(withDuration: 0.25, animations: {
//            self.imageView.frame = endFrame
//            self.bgView.alpha = 0
//        }) { (finish) in
//            self.imageView.removeFromSuperview()
//            self.bgView.removeFromSuperview()
//            self.isFirst = true
//            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
//        }
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
            }
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.transitionContext.containerView.alpha = 0
                self.transitionContext.containerView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            }, completion: { (finish) in
                self.imageView.removeFromSuperview()
                self.bgView.removeFromSuperview()
                self.isFirst = true
                self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
            });
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
