//
//  PageView.swift
//  XMGTV
//
//  Created by X-Liang on 2017/4/7.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit
//
//protocol PageViewDelegate: class {
//    func pageView(_ pageView: PageView, targetIndex: Int)
//}

class PageView: UIView {
    
//    weak var pageViewDelegate: PageViewDelegate?
    
    // Mark: read-only property
    fileprivate(set) var titles: [String]
    fileprivate(set) var childViewControllers: [UIViewController]
    fileprivate(set) var parentViewController: UIViewController
    
    // Mark: lazy property
    fileprivate lazy var titleView: PageTitleView = {
        return PageTitleView(frame:CGRect(x: 0, y: 0, width: self.bounds.width, height: self.titleViewStyle.titleViewHeight) , titles: self.titles, style: self.titleViewStyle)
        }()
    
    fileprivate lazy var contentView: PageContentView = {
        return PageContentView(frame: CGRect(x: 0, y: self.titleViewStyle.titleViewHeight, width: self.bounds.width, height: self.bounds.height - self.titleViewStyle.titleViewHeight), childViewControllers: self.childViewControllers, parentViewController: self.parentViewController)
        }()
    
    var titleViewStyle: PageTitleViewStyle = PageTitleViewStyle() {
        didSet {
            // update titleView，contentView frame
            titleView.frame = CGRect(x: titleView.frame.origin.x, y: titleView.frame.origin.y, width: titleView.bounds.width, height: titleViewStyle.titleViewHeight)
            contentView.frame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: bounds.height - titleView.frame.maxY)
            setNeedsLayout()
        }
    }
    
    init(frame: CGRect, titles: [String], childViewControllers: [UIViewController], parentViewController: UIViewController) {
        self.titles = titles
        self.childViewControllers = childViewControllers
        self.parentViewController = parentViewController
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageView {
    fileprivate func setupUI() {
        addSubview(titleView)
        addSubview(contentView)
        parentViewController.automaticallyAdjustsScrollViewInsets = false
        titleView.titleViewDelegate = contentView
        contentView.contentViewDelegate = titleView
    }
    
    private func setupTitleView() {
    }
    
    private func setupContentView() {
        
    }
}
