//
//  AppDelegate.swift
//  轮播图
//
//  Created by lanou on 16/1/8.
//  Copyright © 2016年 张建军. All rights reserved.

import UIKit

class ViewController: UIViewController {

    var csv : CircleSlide? = nil
    
    override func loadView() {
        self.csv = CircleSlide(frame: UIScreen.mainScreen().bounds)
        self.view = csv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array = ["0.jpg", "1.jpg", "2.jpg", "3.jpg", "4.jpg"]
        self.csv?.bindImageArray(array)
        self.csv?.setSpeed(2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

