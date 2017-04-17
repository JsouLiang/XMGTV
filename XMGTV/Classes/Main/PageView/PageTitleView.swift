//
//  PageTitleView.swift
//  XMGTV
//
//  Created by X-Liang on 2017/4/7.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate: class {
    func pageTitleView(_ titleView: PageTitleView, targetIndex: Int)
}

class PageTitleView: UIView {
    
    weak var titleViewDelegate: PageTitleViewDelegate?
    
    fileprivate(set) var titles: [String]
    fileprivate(set) var titleViewStyle: PageTitleViewStyle
    fileprivate var preSelectedIndex: Int!
    fileprivate var labels: [UILabel]!
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = .gray
        return scrollView
    }()
    
    init(frame: CGRect, titles: [String], style: PageTitleViewStyle) {
        self.titles = titles
        self.titleViewStyle = style
        
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView {
    fileprivate func setupUI() {
        //
        addSubview(scrollView)
        addTitleLabels()
    }
    
    private func addTitleLabels() {
        var x: CGFloat = 20
        labels = Array()
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel(frame: CGRect(x: x, y: 0, width: 30, height: CGFloat(titleViewStyle.titleViewHeight)))
            titleLabel.text = title
            titleLabel.textColor = i == 0 ? titleViewStyle.selectedColor : titleViewStyle.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: titleViewStyle.normalFontSize)
            titleLabel.sizeToFit()
            titleLabel.center.y = center.y
            titleLabel.tag = i
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tapGesture:)))
            titleLabel.addGestureRecognizer(gesture)
            titleLabel.isUserInteractionEnabled = true
            
            x += titleLabel.bounds.width + 20
            scrollView.addSubview(titleLabel)
            
            if i == 0 {
                preSelectedIndex = 0
            }
            labels.append(titleLabel)
        }
        scrollView.contentSize = CGSize(width: x, height: 0)
    }
}

extension PageTitleView {
    @objc fileprivate func tapLabel(tapGesture: UITapGestureRecognizer) {
        // 取出点击的Label
        guard let tapLabel = tapGesture.view as? UILabel  else {
            return
        }
        tapLabel.textColor = titleViewStyle.selectedColor
        labels[preSelectedIndex].textColor = titleViewStyle.normalColor
        
        // 调整选中Label的位置
        updateTitleLabelOffSet(currentLabel: tapLabel)
        if let titleViewDelegate = titleViewDelegate {
            titleViewDelegate.pageTitleView(self, targetIndex: tapLabel.tag)
        }
        
        preSelectedIndex = tapLabel.tag

    }
}

extension PageTitleView: PageContentViewDelegate {
    func pageContentView(_ contentView: PageContentView, targetIndex: Int) {
        if targetIndex == preSelectedIndex {
            return
        }
        let currentLabel = labels[targetIndex]
        
        labels[preSelectedIndex].textColor = titleViewStyle.normalColor
        currentLabel.textColor = titleViewStyle.selectedColor
        
        updateTitleLabelOffSet(currentLabel: currentLabel)
        preSelectedIndex = targetIndex
    }
    
    func pageContentViewDidScroll(_ contenView: PageContentView, targetIndex: Int, progress: CGFloat) {
        let targetLabel = labels[targetIndex]
        let currentLabel = labels[preSelectedIndex]
        
        // 颜色渐变
//        let rgbDelta = UIColor.getRGBDelta(firstColor: titleViewStyle.normalColor, secondColor: titleViewStyle.selectedColor)
//        let normalRGB = titleViewStyle.normalColor.getRGB()
//        let selectedRGB = titleViewStyle.selectedColor.getRGB()
//        targetLabel.textColor = UIColor(r: normalRGB.0 + rgbDelta.0 * progress, g: normalRGB.1 + rgbDelta.1 * progress, b: normalRGB.2 + rgbDelta.2 * progress)
//        currentLabel.textColor = UIColor(r: selectedRGB.0 - rgbDelta.0 * progress, g: selectedRGB.1 - rgbDelta.1 * progress, b: selectedRGB.2 - rgbDelta.2 * progress)

    }
    

    
    fileprivate func updateTitleLabelOffSet(currentLabel: UILabel) {
        // 调整选中Label的位置
        if scrollView.contentSize.width > scrollView.bounds.width {
            let contentSizeWidth = scrollView.contentSize.width
            let scrollViewBoundsWidth = scrollView.bounds.width
            let targetCenterX = currentLabel.center.x
            var offsetX = targetCenterX - scrollViewBoundsWidth * 0.2
            if offsetX < 0 {
                offsetX = 0
            } else if (offsetX > contentSizeWidth - scrollViewBoundsWidth) {
                offsetX = contentSizeWidth - scrollViewBoundsWidth
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}
