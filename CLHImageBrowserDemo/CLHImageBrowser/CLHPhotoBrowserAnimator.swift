//
//  CLHPhotoBrowserAnimator.swift
//  GankJiZhongYing
//
//  Created by AnICoo1 on 2017/8/11.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

import UIKit


/// 图片查看动画协议
protocol CLHPhotoBrowserAnimatorPresentDelegate{
    
    /// 获取图片浏览前在窗口的位置
    ///
    /// - Parameter index: 图片的下标
    /// - Returns: 图片在窗口的位置
    func startRect(index: NSInteger) -> CGRect
    
    /// 获取图片浏览时的位置
    ///
    /// - Parameter index: 图片的下标
    /// - Returns: 图片在图片查看器中的位置
    func endRect(index: NSInteger) -> CGRect
    
    /// 获取当前要浏览的图片
    ///
    /// - Parameter index: 图片的下标
    /// - Returns: 当前要浏览的图片
    func locImageView(index: NSInteger) -> UIImageView
    
}

protocol CLHPhotoBrowserAnimatorDismissDelegate {
    /// 获取当前浏览的图片的下标
    ///
    /// - Returns: 当前浏览图片的下标
    func indexForDismissView() -> NSInteger
    
    /// 获取当前浏览的图片
    ///
    /// - Returns: 当前浏览的图片
    func imageViewForDismissView() -> UIImageView
}

class CLHPhotoBrowserAnimator: NSObject {
    var photoAnimationPresentDelegate: CLHPhotoBrowserAnimatorPresentDelegate?
    var photoAnimationDismissDelegate: CLHPhotoBrowserAnimatorDismissDelegate?
    
    /// 当前所查看的图片的下标
    var index: NSInteger?
    
    /// 判断当前动画是弹出还是消失
    var isPresented: Bool = false
}

extension CLHPhotoBrowserAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            animationForPresentView(transitionContext: transitionContext)
        } else {
            animationForDismissView(transitionContext: transitionContext)
        }
    }
    ///自定义弹出动画
    func animationForPresentView(transitionContext: UIViewControllerContextTransitioning) {
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        transitionContext.containerView.addSubview(presentView!)
        
        let startRect: CGRect = (photoAnimationPresentDelegate?.startRect(index: index!))!
        let endRect: CGRect = (photoAnimationPresentDelegate?.endRect(index: index!))!
        let imageView: UIImageView = (photoAnimationPresentDelegate?.locImageView(index: index!))!
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        presentView?.alpha = 0.0
        transitionContext.containerView.backgroundColor = .black
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
            imageView.frame = endRect
        }) { (finished: Bool) in
            presentView?.alpha = 1.0
            imageView.removeFromSuperview()
            transitionContext.containerView.backgroundColor = .clear
            //告诉上下文动画完成
            transitionContext.completeTransition(true)
        }
    }
    /// 自定义消失动画
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        dismissView?.removeFromSuperview()
        let imageView: UIImageView = (photoAnimationDismissDelegate?.imageViewForDismissView())!
        transitionContext.containerView.addSubview(imageView)
        let idx = photoAnimationDismissDelegate?.indexForDismissView()
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
            imageView.frame = (self.photoAnimationPresentDelegate?.startRect(index: idx!))!
        }) { (finished: Bool) in
            //告诉上下文动画完成
            transitionContext.completeTransition(true)
        }
    }
}
