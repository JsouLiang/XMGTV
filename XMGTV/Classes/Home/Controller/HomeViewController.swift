//
//  HomeViewController.swift
//  XMGTV
//
//  Created by X-Liang on 2017/4/6.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }
}

extension HomeViewController {
    fileprivate func setupUI() {
        setupNavigation()
        setupContentView()
    }
    
    private func setupContentView() {
        let homeTypes = loadAnchorTypeData()
        
        let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
        let titles = homeTypes.map({$0.title})
        var childVCs = [AnchorViewController]()
        for type in homeTypes {
            let anchorVC = AnchorViewController()
            anchorVC.homeType = type
            childVCs.append(anchorVC)
        }
        let pageView = PageView(frame: pageFrame, titles: titles, childViewControllers: childVCs, parentViewController: self)
        view.addSubview(pageView)
    }
    
    private func setupNavigation() {
        // 左侧logoItem
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        // 右侧收藏Item
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemClick))
        
        // 搜索框
        let searchFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
    }
    
    fileprivate func loadAnchorTypeData() -> [HomeType] {

        guard let path = Bundle.main.path(forResource: "types", ofType: ".plist"), let dataArray = NSArray(contentsOfFile: path) as? [[String : Any]] else {
            return [HomeType]()
        }
        var tempArray = [HomeType]()
        for dic in dataArray {
            tempArray.append(HomeType(dict: dic))
        }
        return tempArray
    }
    
    @objc private func collectItemClick() {
        
    }
}
