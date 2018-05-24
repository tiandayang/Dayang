//
//  DYPhotoPreViewFlowLayout.swift
//  Dayang
//
//  Created by 田向阳 on 2017/8/31.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit

private let kItemSpace = 30.0

class DYPhotoPreViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
    }
    //实时刷新
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //计算每个 item的 位置
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attArrays = super.layoutAttributesForElements(in: rect)
        if attArrays == nil {
            return attArrays
        }
        var resultArray = [UICollectionViewLayoutAttributes]()
        let  centerX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.bounds.size.width)! * 0.5;
        for att in attArrays! {
            let resultAtt = att.copy() as! UICollectionViewLayoutAttributes
            let offset = abs(resultAtt.center.x - centerX)
            let scale = 1 - offset / (self.collectionView?.bounds.size.width)! * 0.5
            resultAtt.transform = CGAffineTransform(scaleX: scale, y: scale)
            resultArray.append(resultAtt)
        }
        return resultArray
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //        let rect = CGRect.init(origin: proposedContentOffset, size: (self.collectionView?.bounds.size)!)
        //        let attArray = super.layoutAttributesForElements(in: rect)
        //        if attArray == nil {
        //            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        //        }
        //        var gap = 1000
        //        var offset = CGFloat(0.0)
        //        for att in attArray! {
        //            if CGFloat(gap) > abs(att.center.x - proposedContentOffset.x - (self.collectionView?.bounds.size.width)! * 0.5) {
        //                gap = abs(Int(att.center.x - proposedContentOffset.x - (self.collectionView?.bounds.size.width)! * 0.5))
        //                offset = att.center.x - proposedContentOffset.x - (self.collectionView?.bounds.size.width)! * 0.5
        //            }
        //        }
        //        let point = CGPoint.init(x: proposedContentOffset.x + offset , y: proposedContentOffset.y)
        //        return point
        //
        
        var offsetAdjustment = MAXFLOAT
        
        //CGRectGetWidth: 返回矩形的宽度
        let horizontalCenter = proposedContentOffset.x + (self.collectionView?.frame.size.width ?? 0) / 2.0
        
        //当前rect
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView?.bounds.size.width ?? 0, height: self.collectionView?.bounds.size.height ?? 0)
        
        let array = super.layoutAttributesForElements(in: targetRect)
        //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
        for att in array! {
            att.transform = CGAffineTransform(scaleX: 1, y: 1)
            let itemHorizontalCenter = att.center.x;
            if (abs(itemHorizontalCenter - horizontalCenter) < CGFloat(abs(offsetAdjustment)))
            {
                //与中心的位移差
                offsetAdjustment = Float(itemHorizontalCenter - horizontalCenter);
            }
        }
        //返回修改后停下的位置
        return CGPoint(x:proposedContentOffset.x +  CGFloat(offsetAdjustment), y: proposedContentOffset.y);
    }
}
