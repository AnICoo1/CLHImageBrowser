//
//  CLHPhotoBrowser.swift
//  GankJiZhongYing
//
//  Created by AnICoo1 on 2017/8/11.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

import UIKit

let kScreenW: CGFloat = UIScreen.main.bounds.size.width
let kScreenH: CGFloat = UIScreen.main.bounds.size.height

let margin: CGFloat = 10
class CLHPhotoBrowser: UIView {

    ////animator
    let animator: CLHPhotoBrowserAnimator = {
        let ani = CLHPhotoBrowserAnimator()
        return ani
    }()
    
    var imageDataArrayFromURL: [String]?
    
    var imageDataArrayFromLocal: [String]?
    
    func show() {
        //全部为空
        if (imageDataArrayFromLocal == nil) && (imageDataArrayFromURL == nil) {
            return
        }
        for v in subviews {
            if v.isKind(of: UIImageView.self) {
                let imageV = v as! UIImageView
                imageV.removeFromSuperview()
                
            }
        }
        if imageDataArrayFromLocal != nil {
            showLocalImage()
        }
        if imageDataArrayFromURL != nil {
            showURLImage()
        }
    }
}



extension CLHPhotoBrowser {
    func showLocalImage() {
        let count = (imageDataArrayFromLocal == nil) ? 0 : (imageDataArrayFromLocal?.count)!
        //设置imageView宽高
        let imageW: CGFloat = getWidthOfImageView()
        var imageH: CGFloat = 0
        imageH = imageW
        let numberPerRow = getNumberOfPerRow()
        
        for i in 0..<count {
            let imageV = UIImageView()
            imageV.isUserInteractionEnabled = true
            imageV.backgroundColor = .blue
            imageV.tag = i + 2000
            imageV.image = UIImage(named: (imageDataArrayFromLocal?[i])!)
            let column = i % numberPerRow
            let row = i / numberPerRow
            let imageX: CGFloat = CGFloat(column) * (imageW + 5.0)
            let imageY = CGFloat(row) * (imageH + 5.0)
            imageV.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(click(tap:)))
            imageV.addGestureRecognizer(tap)
            addSubview(imageV)
        }
    }
    
    func showURLImage() {
        let count = (imageDataArrayFromURL == nil) ? 0 : (imageDataArrayFromURL?.count)!
        if count == 0 {
            return
        }
        let locCount = (imageDataArrayFromLocal == nil) ? 0 : (imageDataArrayFromLocal?.count)!
        //设置imageView宽高
        let imageW: CGFloat = getWidthOfImageView()
        var imageH: CGFloat = 0
        imageH = imageW
        
        let numberPerRow = getNumberOfPerRow()
        for i in 0..<count {
            let imageV = UIImageView()
            imageV.isUserInteractionEnabled = true
            imageV.backgroundColor = .blue
            imageV.tag = i + locCount + 2000
            imageV.downloadedFrom(url: URL(string: (imageDataArrayFromURL?[i])!)!)
            let column = (i + locCount) % numberPerRow
            let row = (i + locCount) / numberPerRow
            let imageX: CGFloat = CGFloat(column) * (imageW + 5.0)
            let imageY = CGFloat(row) * (imageH + 5.0)
            imageV.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(click(tap:)))
            imageV.addGestureRecognizer(tap)
            addSubview(imageV)
            print(imageV.isUserInteractionEnabled)
        }

    }
}

extension CLHPhotoBrowser: CLHPhotoBrowserAnimatorPresentDelegate{
    func startRect(index: NSInteger) -> CGRect {
        var imageView: UIImageView? = nil
        for i in 0..<subviews.count {
            if subviews[i].isKind(of: UIImageView.self) {
                if subviews[i].tag == index + 2000 {
                    imageView = subviews[i] as? UIImageView
                }
            }
        }
        return convert((imageView?.frame)!, to: UIApplication.shared.keyWindow)
    }
    
    func endRect(index: NSInteger) -> CGRect {
        let imageView = self.viewWithTag(index + 2000) as! UIImageView
        let image = imageView.image
        let x: CGFloat = 0
        let width: CGFloat = kScreenW
        let height: CGFloat = width / (image!.size.width) * (image!.size.height)
        var y: CGFloat = 0
        if height < kScreenH {
            y = (kScreenH - height) * 0.5
        }
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func locImageView(index: NSInteger) -> UIImageView {
        let imageV = self.viewWithTag(index + 2000) as! UIImageView
        let imageView = UIImageView()
        imageView.image = imageV.image
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }
}


extension CLHPhotoBrowser {
    
    func click(tap: UITapGestureRecognizer) {
        let photoVC = CLHPhotoBrowserViewController()
        photoVC.imageArray = [UIImage]()
        for V in subviews {
            if V.isKind(of: UIImageView.self){
                let imageV = V as! UIImageView
                photoVC.imageArray?.append(imageV.image!)
            }
        }
        photoVC.indexPath = IndexPath(row: (tap.view?.tag)! - 2000, section: 0)
        photoVC.modalPresentationStyle = .custom
        photoVC.transitioningDelegate = animator
        
        animator.photoAnimationPresentDelegate = self
        animator.photoAnimationDismissDelegate = photoVC
        animator.index = (tap.view?.tag)! - 2000
        
        self.window?.rootViewController?.present(photoVC, animated: true, completion: nil)
    }
    
    fileprivate func getWidthOfImageView() -> CGFloat {
        
        var ansWidth: CGFloat = (self.frame.size.width - margin * 2.0) / 3.0
        if self.frame.size.height < ansWidth {
            ansWidth = self.frame.size.height
        }
        return ansWidth
    }
    
    fileprivate func getNumberOfPerRow() -> NSInteger {
        return 3;
    }
}
