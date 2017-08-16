//
//  CLHPhotoBrowserViewController.swift
//  GankJiZhongYing
//
//  Created by AnICoo1 on 2017/8/11.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

import UIKit

class CLHPhotoBrowserViewController: UIViewController {

    
    var imageArray: [UIImage]?
    var indexPath: IndexPath?
    
    lazy var pageControl: UIPageControl = {
        
        let pageCtrl = UIPageControl(frame: CGRect(x: 0, y: kScreenH - 40, width: kScreenW, height: 20))
        pageCtrl.currentPage = 1
        pageCtrl.isUserInteractionEnabled = false
        
        return pageCtrl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenW, height: kScreenH)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionV.register(CLHPhotoCell.self, forCellWithReuseIdentifier: "cell")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.isPagingEnabled = true
        collectionV.frame = self.view.bounds
        return collectionV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAll()
        //跳转到指定页
        collectionView.scrollToItem(at: indexPath!, at: .left, animated: false)
        pageControl.currentPage = (indexPath?.row)!
    }
    
    fileprivate func setUpAll() {
        self.view.addSubview(pageControl)
        self.view.insertSubview(collectionView, at: 0)
    }
    
}

//MARK: - UICollectionViewDelegate，UICollectionViewDataSource
extension CLHPhotoBrowserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = imageArray?.count
        pageControl.numberOfPages = count!
        return count!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CLHPhotoCell
        cell.imageView = UIImageView(image: imageArray?[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset: CGFloat = scrollView.contentOffset.x
        if contentOffset < 0 {
            pageControl.currentPage = 0
            return
        }
        let page: Int = Int(contentOffset / scrollView.frame.size.width) + ((Int(contentOffset) % Int(scrollView.frame.size.width)) == 0 ? 0 : 1)
        pageControl.currentPage = page
    }
}

//MARK: - CLHPhotoBrowserCellDelegate
extension CLHPhotoBrowserViewController: CLHPhotoBrowserCellDelegate {
    func imageViewDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CLHPhotoBrowserViewController: CLHPhotoBrowserAnimatorDismissDelegate {
    func indexForDismissView() -> NSInteger {
        let cell = collectionView.visibleCells.first
        return (collectionView.indexPath(for: cell!)?.row)!
    }
    
    func imageViewForDismissView() -> UIImageView {
        let imageView = UIImageView()
        let cell = collectionView.visibleCells.first as! CLHPhotoCell
        imageView.image = cell.imageView?.image
        imageView.frame = (cell.imageView?.frame)!
        cell.contentMode = .scaleToFill
        cell.clipsToBounds = true
        return imageView
    }
}

