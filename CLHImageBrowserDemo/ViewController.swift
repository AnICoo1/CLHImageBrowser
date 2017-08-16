//
//  ViewController.swift
//  CLHImageBrowserDemo
//
//  Created by AnICoo1 on 2017/8/16.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageBrowser = CLHPhotoBrowser(frame: CGRect(x: 50, y: 200, width: 250, height: 100))
        imageBrowser.imageDataArrayFromLocal = ["3", "4", "5", "6", "7", "8"]
        view.addSubview(imageBrowser)
        imageBrowser.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

