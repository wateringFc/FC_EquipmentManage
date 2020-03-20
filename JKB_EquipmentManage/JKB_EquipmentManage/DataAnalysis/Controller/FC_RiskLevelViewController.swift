//
//  FC_RiskLevelViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/24.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_RiskLevelViewController: UIViewController {
    
    /// 当前选择按钮
    var selectedButton: UIButton?
    
    /// 背景指示器
    fileprivate lazy var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = HexColor(0xBE2207)
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = 13.5
        return indicatorView
    }()
    
    /// 顶部的背景视图
    fileprivate lazy var titlesView: UIView = {
        let titlesView = UIView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenW, height: 42))
        titlesView.backgroundColor = UIColor.clear
        return titlesView
    }()
    
    /// 彩色线条
    fileprivate lazy var lineColorImg: UIImageView = {
        let lineColorImg = UIImageView(frame: CGRect(x: 0, y: kNavBarHeight + 40, width: kScreenW, height: 2))
        lineColorImg.image = UIImage(named: "gradientColor_line")
        return lineColorImg
    }()
    
    /// 底部滑动视图
    fileprivate lazy var contenView: UIScrollView = {
        let contenView = UIScrollView()
        contenView.backgroundColor = UIColor.white
        contenView.frame = view.bounds
        contenView.delegate = self
        contenView.isPagingEnabled = true
        contenView.contentSize = CGSize(width: contenView.width * CGFloat(childViewControllers.count), height: 0)
        return contenView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpChinldVces()
        setUptitlesView()
        setUpContenView()
    }
}

extension FC_RiskLevelViewController {
    
    /// 初始化子控制器
    fileprivate func setUpChinldVces() {
        let highestVc = FC_LevelViewController()
        highestVc.title = "高危"
        highestVc.type = .LeveType_highest
        addChildViewController(highestVc)
        
        let highVc = FC_LevelViewController()
        highVc.title = "危险"
        highVc.type = .LeveType_high
        addChildViewController(highVc)
        
        let generalVc = FC_LevelViewController()
        generalVc.title = "一般"
        generalVc.type = .LeveType_general
        addChildViewController(generalVc)
    }
    
    /// 设置顶部的标签栏
    fileprivate func setUptitlesView() {
        
        // 添加指示器
        view.addSubview(indicatorView)
        indicatorView.height = 27
        indicatorView.y = kNavBarHeight + 7
        // 添加标题视图
        view.addSubview(titlesView)
        // 添加彩色线条
        view.addSubview(lineColorImg)
        
        // 创建按钮
        let item_w: CGFloat = titlesView.width/CGFloat(self.childViewControllers.count)
        let item_h: CGFloat = titlesView.height
        for i in 0..<childViewControllers.count {
            let but = UIButton(type: .custom)
            let but_x = CGFloat(i) * item_w
            but.frame = CGRect(x: but_x, y: 0, width: item_w, height: item_h)
            let vc = childViewControllers[i]
            but.setTitle(vc.title, for: .normal)
            but.setTitleColor(Sub_666666_Color, for: .normal)
            but.setTitleColor(UIColor.white, for: .disabled)
            but.tag = i
            but.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            but.addTarget(self, action: #selector(titlesClick(but:)), for: .touchUpInside)
            titlesView.addSubview(but)
            
            if i == 0 {
                but.isEnabled = false
                selectedButton = but
                but.titleLabel?.sizeToFit()
                indicatorView.width = but.titleLabel!.width*2.6
                indicatorView.centerX = but.centerX
            }
        }
    }
    
    /// 底部的scrollView
    fileprivate func setUpContenView() {
        view.insertSubview(contenView, at: 0)
        // 默认添加第一个控制器
        scrollViewDidEndScrollingAnimation(contenView)
    }
    
    @objc func titlesClick(but: UIButton) {
        // 修改标签状态
        selectedButton?.isEnabled = true
        but.isEnabled = false
        selectedButton = but
        UIView.animate(withDuration: 0.25) {
            self.indicatorView.width = self.selectedButton!.titleLabel!.width * 2.6
            self.indicatorView.centerX = self.selectedButton!.centerX
            if but.tag == 0 {
                self.indicatorView.backgroundColor = HexColor(0xBE2207)
            }else if but.tag == 1 {
                self.indicatorView.backgroundColor = HexColor(0xFCB74A)
            }else {
                self.indicatorView.backgroundColor = HexColor(0x5CC2F2)
            }
        }
        
        // 滚动子控制器
        var offset = contenView.contentOffset
        offset.x = CGFloat(but.tag) * contenView.width
        contenView.setContentOffset(offset, animated: true)
    }
}

extension FC_RiskLevelViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let vc = childViewControllers[index]
        vc.view.x = scrollView.contentOffset.x
        vc.view.y = 42
        vc.view.height = scrollView.height - 42 - kSafeBottomAreaH - kNavBarHeight
        scrollView.addSubview(vc.view)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        titlesClick(but: titlesView.subviews[index] as! UIButton)

    }
}
