//
//  CLHPhotoCell.swift
//  GankJiZhongYing
//
//  Created by AnICoo1 on 2017/8/11.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

import UIKit


/// 图片查看协议
protocol CLHPhotoBrowserCellDelegate {
    
    /// 图片查看器被点击事件
    func imageViewDidClick()
}

class CLHPhotoCell: UICollectionViewCell {
    var delegate: CLHPhotoBrowserCellDelegate?
    
    var scrollView: UIScrollView?
    var imageView: UIImageView! {
        didSet{
            let image = imageView.image
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true
            
            let x: CGFloat = 0
            var y: CGFloat = 0
            let width = kScreenW
            let height = width / (image?.size.width)! * (image?.size.height)!
            
            if height < kScreenH {
                y = (kScreenH - height) * 0.5
            }
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            
            scrollView = UIScrollView(frame: self.bounds)
            scrollView?.contentSize = CGSize(width: 0, height: height)
            scrollView?.addSubview(imageView)
            
            contentView.addSubview(scrollView!)
        }
    }
    
    func imageViewClick() {
        delegate?.imageViewDidClick()
    }

}
