//
//  AppDelegate.swift
//  轮播图
//
//  Created by lanou on 16/1/8.
//  Copyright © 2016年 张建军. All rights reserved.
//

import UIKit

class CircleSlide: UIView,UIScrollViewDelegate {

    //保存ImageView上显示的图片的名字
    var centerImageNamed : NSString? = nil
    var leftImageNamed: NSString? = nil
    var rightImageNamed : NSString? = nil
    //存储图片名字的数组
    var imageArray : NSMutableArray? = nil
    //定时器
    //var timer : NSTimer? = nil
    //是否启动了定时器
    var isTimerStart : Bool? = nil
    //定时器的速度
    var timerInterval : Double? = nil

    //设置自动轮播的速度
    func setSpeed(time : Double) {
        
        if self.imageArray?.count < 2 {
            return
        }
        
        //设置定时器
        self.timer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: Selector("timerAction"), userInfo: nil, repeats: true)
        self.isTimerStart = true
        self.timerInterval = time
    }
    
    //定时器实现的轮播效果
    func timerAction() {
        self.slideToLeft()
    }
    
    //当开始拖动时停止定时器
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.timer.invalidate()
        //self.timer = nil
    }
    
    //实现轮播图的方法
    func bindImageArray(imageArray : NSArray) {
        self.imageArray = NSMutableArray(array: imageArray)
        
        if self.imageArray?.count == 0 {
            return
        } else if self.imageArray?.count == 1 {
            
            self.addSubview(self.scrollView)
            self.scrollView.addSubview(self.leftImageView)
            self.leftImageNamed = self.imageArray![0] as? NSString
            self.leftImageView.image = UIImage(named: self.leftImageNamed as! String)
            self.scrollView.contentSize = CGSizeMake(self.frame.size.width, 0)
            return
            
        }
        
        //把scrollView放到自己的subView上
        self.addSubview(self.scrollView)
        //把三张图片添加到scrollView上
        self.scrollView.addSubview(self.leftImageView)
        self.scrollView.addSubview(self.centerImageView)
        self.scrollView.addSubview(self.rightImageView)
        //保证刚出现的时候，正中间显示的是第一张照片
        //左边显示最后一张，右边显示第二张
        //核心思想：图片不动数据动
        self.centerImageNamed = self.imageArray![0] as? NSString
        self.leftImageNamed = self.imageArray![(self.imageArray?.count)! - 1] as? NSString
        self.rightImageNamed = self.imageArray![1] as? NSString
        //把图片放到imageView上，对应位置的imageView放置对应的图片
        self.centerImageView.image = UIImage(named: self.centerImageNamed as! String)
        self.leftImageView.image = UIImage(named: self.leftImageNamed as! String)
        self.rightImageView.image = UIImage(named: self.rightImageNamed as! String)
        //设置偏移量显示centerImageView
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0)
        //隐藏scrollView的滚动条---水平方向
        self.scrollView.showsHorizontalScrollIndicator = false
        //把pageControl添加到视图上
        self.addSubview(self.pages)
        self.pages.numberOfPages = (self.imageArray?.count)!
        self.pages.currentPage = 0
    }
    
    //scrollView的delegate，实现图片不动数据动的方法
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            self.slideToRight()
        } else if scrollView.contentOffset.x == self.scrollView.bounds.size.width * 2 {
            self.slideToLeft()
        }
        if self.isTimerStart == true {
            self.setSpeed(self.timerInterval!)
        }
    }
    
    func slideToRight() {
        // 替换数据源
        // 让centerImageNamed保存的是leftIamgeNamed
        // 让rightImageNamed保存的是centerImageNamed
        // 更新leftImageNamed的数据
        
        // 先替换rightImageNamed再替换centerImageNamed
        rightImageNamed = centerImageNamed;
        centerImageNamed = leftImageNamed;
        let index = self.imageOnImageArrayWithImageString(leftImageNamed!)
        
        if index == 0 {
            leftImageNamed = self.imageArray![self.imageArray!.count - 1] as? NSString
        } else {
            leftImageNamed = self.imageArray![index - 1] as? NSString
        }
        
        self.centerImageView.image = UIImage(named: self.centerImageNamed as! String)
        self.leftImageView.image = UIImage(named: self.leftImageNamed as! String)
        self.rightImageView.image = UIImage(named: self.rightImageNamed as! String)
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0)
        
        if self.pages.currentPage == 0 {
            
            self.pages.currentPage = self.imageArray!.count - 1
            
        } else {
            
            self.pages.currentPage = self.pages.currentPage - 1
            
        }
    }
    
    func slideToLeft() {
        //实现原理与向右滑动一样
        leftImageNamed = centerImageNamed;
        centerImageNamed = rightImageNamed;
        let index = self.imageOnImageArrayWithImageString(self.rightImageNamed!)
        
        if index == self.imageArray!.count - 1 {
            self.rightImageNamed = self.imageArray![0] as? NSString;
        } else {
            self.rightImageNamed = self.imageArray![index + 1] as? NSString;
        }
        
        self.centerImageView.image = UIImage(named: self.centerImageNamed as! String)
        self.leftImageView.image = UIImage(named: self.leftImageNamed as! String)
        self.rightImageView.image = UIImage(named: self.rightImageNamed as! String)
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0)
        
        if self.pages.currentPage == self.imageArray!.count - 1 {
            
            self.pages.currentPage = 0;
            
        } else {
            
            self.pages.currentPage = self.pages.currentPage + 1
            
        }
    }
    
    func imageOnImageArrayWithImageString(imageString : NSString) -> NSInteger {
        for var i = 0; i < self.imageArray?.count; i++ {
            if imageString == self.imageArray![i] as! NSObject {
                return i
            }
        }
        return 0
    }
    
    //懒加载
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
        return scrollView
    }()
    
    lazy var pages : UIPageControl = {
        let pages = UIPageControl(frame: CGRectMake((self.bounds.size.width - 110)/2.0, self.scrollView.bounds.size.height - 30, 110, 30))
        pages.pageIndicatorTintColor = UIColor.lightGrayColor()
        pages.currentPageIndicatorTintColor = UIColor.orangeColor()
        return pages
    }()
    
    lazy var leftImageView : UIImageView = {
        let leftImageView = UIImageView(frame: CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height))
        return leftImageView
    }()
    
    lazy var centerImageView : UIImageView = {
        let centerImageView = UIImageView(frame: CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height))
        return centerImageView
    }()
    
    lazy var rightImageView : UIImageView = {
        let rightImageView = UIImageView(frame: CGRectMake(self.scrollView.frame.size.width * 2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height))
        return rightImageView
    }()
    
    lazy var timer : NSTimer = {
        let timer = NSTimer()
        return timer
    }()
    
}
