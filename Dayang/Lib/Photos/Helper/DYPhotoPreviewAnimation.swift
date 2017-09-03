//
//  DYPhotoPreviewAnimation.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/1.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let animationDuration = 0.18

class DYPhotoPreviewAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var thumbTapView: UIImageView? //点击的view
    
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
        
        let toVC = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView;
        
        toVC?.view.alpha = 0
        let startFrame = self.thumbTapView?.superview?.convert((thumbTapView?.frame)!, to: (UIApplication.shared.delegate?.window)!)
        let endFrame = scaleImageFrame(image: (self.thumbTapView?.image)!)
        containerView.insertSubview((toVC?.view)!, aboveSubview: containerView)
        let imageView = UIImageView.init(frame: startFrame!)
        imageView.image = self.thumbTapView?.image
        containerView.insertSubview(imageView, aboveSubview: (toVC?.view)!)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveLinear, animations: { 
            imageView.frame = endFrame
        }) { (finish) in
            toVC?.view.alpha = 1
            imageView.removeFromSuperview()
            transitionContext.completeTransition(finish)
        }
    }
//    dismiss Animation
    private func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) as! DYPhotoPreviewController
        let containerView = transitionContext.containerView
        
        let cell = fromVC.collectionView.visibleCells.first as! DYPhotoPreviewBaseCell
        
        let animationView = UIImageView()
        animationView.image = cell.imageView?.image
        animationView.frame = scaleImageFrame(image: animationView.image!)

        containerView.addSubview(animationView)
        containerView.addSubview(fromVC.view)
        let rect = UIScreen.main.bounds
        let endFrame = self.thumbTapView?.superview?.convert((thumbTapView?.frame)!, to: (UIApplication.shared.delegate?.window)!)
        if self.thumbTapView != nil && endFrame != nil && rect.contains(endFrame!) {
            cell.isHidden = true
                UIView.animate(withDuration: animationDuration, animations: {
                    fromVC.view.alpha = 0
                    animationView.frame = endFrame!
                }, completion: { (finish) in
                    animationView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
        }else{
            animationWithView(view: fromVC.view, animationView: animationView, transitionContext: transitionContext)
        }
    }
    
    private func animationWithView(view: UIView, animationView: UIView,transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: 0.3, animations: {
            transitionContext.containerView.alpha = 0
            transitionContext.containerView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        }) { (finish) in
            animationView.removeFromSuperview()
            self.thumbTapView?.superview?.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
    
    private func  scaleImageFrame(image: UIImage?) -> CGRect {
        if image == nil || image?.size ==  CGSize.zero {
            return CGRect.zero
        }
        let screenSize = UIScreen.main.bounds.size
        let screenScale = screenSize.width / screenSize.height
        let imageScale = (image?.size.width)! / (image?.size.height)!
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        var width = CGFloat(0)
        var height = CGFloat(0)
        
        if imageScale > screenScale {
            width = screenSize.width
            height = width / imageScale
            y = (screenSize.height - height) / 2
        }else{
           height = screenSize.height
            width = height * imageScale
            x = (screenSize.width - width) / 2
        }
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
