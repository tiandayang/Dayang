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
    
    convenience init(gesture: UIPanGestureRecognizer) {
        self.init()
        self.panGesture = gesture
        self.panGesture.addTarget(self, action: #selector(gestureChanged))
    }
    
    deinit {
        self.panGesture.removeTarget(self, action: #selector(gestureChanged))
    }
        
    func gestureChanged(sender: UIPanGestureRecognizer) {
        
        let scale = getTranslationScale()
        if isFirst {
            beginInterPercent()
            isFirst = false
        }
        switch sender.state {
        case .began:
            break
        case.possible:
            break
        case.changed:
            update(getTranslationScale())
            updateInterPercent(scale: getTranslationScale())
            break
        case.ended:
            if scale > 0.8 {
                cancel()
                interPercentCancel()
            }else{
                finish()
                funcinterPercentFinish(scale: scale)
            }

            break
        default:

            break
        }
    }
    
    func beginInterPercent() {
        if transitionContext == nil {
            return
        }
        let fromVC = transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
    }
    
    func interPercentCancel() {
        if transitionContext == nil {
            return
        }
        let fromVC = transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
        let containerView = transitionContext.containerView
        fromVC.view.alpha = 1;
        containerView.addSubview(fromVC.view);
        self.transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    func updateInterPercent(scale: CGFloat) {
        if transitionContext == nil {
            return
        }
        let fromVC = transitionContext.viewController(forKey:.from)
        fromVC?.view.alpha = scale;
    }
    
    
    func funcinterPercentFinish(scale: CGFloat) {
        if transitionContext == nil {
            return
        }
        let fromVC = transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        let imageView = UIImageView()
        let cell = fromVC.collectionView.visibleCells.first as! DYPhotoPreviewBaseCell
        imageView.image = cell.imageView?.image ?? UIImage(named: "photo_PlaceHolder")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = UIImage.scaleImageFrame(image: imageView.image!)
        containerView.addSubview(imageView)
        
        let endFrame = fromVC.thumbTapView?.superview?.convert((fromVC.thumbTapView?.frame)!, to:((UIApplication.shared.delegate?.window)!)!)
        if endFrame != nil && UIScreen.main.bounds.contains(endFrame!){
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveLinear, animations: {
                imageView.frame = endFrame!;
                fromVC.view.alpha = 0;
            }) { (finish) in
                imageView.removeFromSuperview()
                fromVC.view.removeFromSuperview()
                self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
            }
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                containerView.alpha = 0
                self.transitionContext.containerView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            }, completion: { (finish) in
                imageView.removeFromSuperview()
                fromVC.view.removeFromSuperview()
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
