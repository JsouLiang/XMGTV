//
//  PageContentView.swift
//  XMGTV
//
//  Created by X-Liang on 2017/4/7.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(_ contentView: PageContentView, targetIndex: Int)
    func pageContentViewDidScroll(_ contenView: PageContentView, targetIndex: Int, progress: CGFloat)
}

class PageContentView: UIView {
    
    weak var contentViewDelegate: PageContentViewDelegate?
    
    fileprivate(set) var childViewControllers: [UIViewController]
    fileprivate(set) var parentViewController: UIViewController
    
    fileprivate var startOffSetX: CGFloat = 0.0
    
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    init(frame: CGRect, childViewControllers: [UIViewController], parentViewController: UIViewController) {
        self.childViewControllers = childViewControllers
        self.parentViewController = parentViewController
        super.init(frame: frame)
        setupUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 设置UI界面
extension PageContentView {
    fileprivate func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PageContentCell.self, forCellWithReuseIdentifier: "ContentCell")
        addSubview(collectionView)
        
        for childViewController in childViewControllers {
            parentViewController.addChildViewController(childViewController)
            childViewController.didMove(toParentViewController: parentViewController)
        }
    }
}

extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! PageContentCell
        let childVC = childViewControllers[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
//        childVC.view.backgroundColor = UIColor.randomColor()
        cell.content = childVC.view
        return cell
    }
}

extension PageContentView: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard startOffSetX != scrollView.contentOffset.x else {
            return
        }
        
        if let contentViewDelegate = contentViewDelegate {
            var targetIndex = 0
            var progress: CGFloat = 0
            let currentIndex = Int(startOffSetX / scrollView.bounds.width)
            // 左划动
            if startOffSetX < scrollView.contentOffset.x {
                targetIndex = (currentIndex + 1) >= childViewControllers.count ? childViewControllers.count - 1 : (currentIndex + 1)
                progress = (scrollView.contentOffset.x - startOffSetX) / collectionView.bounds.width

            } else {    // 右滑动
                targetIndex = (currentIndex - 1) < 0 ? 0 : currentIndex - 1
                progress = (startOffSetX - scrollView.contentOffset.x) / collectionView.bounds.width
            }

            contentViewDelegate.pageContentViewDidScroll(self, targetIndex: targetIndex, progress: progress)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffSetX = scrollView.contentOffset.x
    }
    
    private func contentEndScroll() {
        // 获取滚动到的位置
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        // 通知titleView滚动到相应为位置
        if let contentViewDelegate = contentViewDelegate {
            contentViewDelegate.pageContentView(self, targetIndex: currentIndex)
        }
    }
}

class PageContentCell: UICollectionViewCell {
    weak var content: UIView? {
        didSet {
            if let oldValue = oldValue{
                oldValue.removeFromSuperview()
            }
            
            if let content = content {
                contentView.addSubview(content)
            }
        }
    }
}

extension PageContentView: PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, targetIndex: Int) {
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: false)
    }
}

