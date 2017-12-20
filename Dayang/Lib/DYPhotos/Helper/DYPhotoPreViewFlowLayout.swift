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
        let  centerX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.mj_w)! * 0.5;
        for att in attArrays! {
            let resultAtt = att.copy() as! UICollectionViewLayoutAttributes
            let offset = abs(resultAtt.center.x - centerX)
            let scale = 1 - offset / (collectionView?.mj_w)! * 0.5
            resultAtt.transform = CGAffineTransform(scaleX: scale, y: scale)
            resultArray.append(resultAtt)
        }
        return resultArray
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect.init(origin: proposedContentOffset, size: (self.collectionView?.mj_size)!)
        let attArray = super.layoutAttributesForElements(in: rect)
        if attArray == nil {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        var gap = 1000
        var offset = CGFloat(0.0)
        for att in attArray! {
            if CGFloat(gap) > abs(att.center.x - proposedContentOffset.x - (collectionView?.mj_w)! * 0.5) {
                gap = abs(Int(att.center.x - proposedContentOffset.x - (collectionView?.mj_w)! * 0.5))
                offset = att.center.x - proposedContentOffset.x - collectionView!.mj_w * 0.5
            }
        }
        let point = CGPoint.init(x: proposedContentOffset.x + offset , y: proposedContentOffset.y)
        return point
    }
}
