//
//  DYPhotoPreviewAnimation.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/1.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

let animationDuration = 0.4

class DYPhotoPreviewAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var thumbTapView: UIImageView! //点击的view not null
    
    init(thumbTapView: UIImageView?) {
        super.init()
        self.thumbTapView = thumbTapView
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)
        if (fromVC?.isKind(of: DYPhotoPreviewController.self))! {
            dismissTransition(transitionContext: transitionContext)
        }else{
            presentTransition(transitionContext: transitionContext)
        }
    }
    // present Animation
    private func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to) as? DYPhotoPreviewController
        let containerView = transitionContext.containerView;
        toVC?.view.alpha = 0
        toVC?.collectionView.isHidden = true
        var endFrame = CGRect.zero
        var startFrame = CGRect.zero
        if self.thumbTapView?.image == nil {
            self.thumbTapView?.image = UIImage(named: "photo_PlaceHolder")
        }
        endFrame = UIImage.scaleImageFrame(image: (self.thumbTapView?.image)!)
        startFrame = (self.thumbTapView?.superview?.convert((thumbTapView?.frame)!, to: getWindow()))!
       
        containerView.insertSubview((toVC?.view)!, aboveSubview: containerView)
        let imageView = UIImageView.init(frame: startFrame)
        imageView.image = self.thumbTapView?.image
        containerView.insertSubview(imageView, aboveSubview: (toVC?.view)!)
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveLinear, animations: {
            imageView.frame = endFrame
            toVC?.view.alpha = 1
        }) { (finish) in
            toVC?.collectionView.isHidden = false
            imageView.removeFromSuperview()
            transitionContext.completeTransition(finish)
            transitionContext.finishInteractiveTransition()
        }
    }
//    dismiss Animation
    private func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
        let containerView = transitionContext.containerView
        
        let cell = fromVC.collectionView.visibleCells.first as! DYPhotoPreviewBaseCell
        
        let imageView = UIImageView()
        imageView.image = cell.imageView?.image ?? UIImage(named: "photo_PlaceHolder")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = UIImage.scaleImageFrame(image: imageView.image!)

        containerView.addSubview(imageView)
        containerView.addSubview(fromVC.view)
        let rect = UIScreen.main.bounds
        let endFrame = self.thumbTapView?.superview?.convert((thumbTapView?.frame)!, to: getWindow())
    
        if self.thumbTapView != nil && endFrame != nil && rect.contains(endFrame!) {
            cell.isHidden = true
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveLinear, animations: {
                    fromVC.view.alpha = 0
                    imageView.frame = endFrame!
                }, completion: { (finish) in
                    imageView.isHidden = true
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                    transitionContext.finishInteractiveTransition()
                })
        }else{
            animationWithView(view: fromVC.view, animationView: imageView, transitionContext: transitionContext)
        }
    }
    
    private func animationWithView(view: UIView, animationView: UIView,transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: animationDuration, animations: {
            transitionContext.containerView.alpha = 0
            transitionContext.containerView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        }) { (finish) in
            animationView.removeFromSuperview()
            self.thumbTapView?.superview?.isHidden = false
            transitionContext.completeTransition(true)
            transitionContext.finishInteractiveTransition()
        }
    }
    
    private func  getWindow() ->UIWindow {
        return ((UIApplication.shared.delegate?.window)!)!
    }
}
