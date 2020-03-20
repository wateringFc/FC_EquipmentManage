//
//  FC_SelectDepartmentView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/21.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_SelectDepartmentView: UIView {

    // 回调点击事件
    var didSelectBlock:(()->())?
    
    fileprivate lazy var starsLb: UILabel = {
        let starsLb = UILabel()
        starsLb.text = "*"
        starsLb.textColor = .red
        return starsLb
    }()
    
    fileprivate lazy var borderView: UIView = {
        let borderView = UIView()
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        return borderView
    }()
    
    fileprivate lazy var img: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "home_down")
        return img
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "所属科室："
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = Normal_000000_Color
        return titleLabel
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel(frame: CGRect(x: 152, y: 0, width: 150, height: 30))
        valueLabel.text = "请选择"
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.textColor = Sub_666666_Color
        return valueLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        starsLb.frame = CGRect(x: 24, y: 0, width: 8, height: 30)
        borderView.frame = CGRect(x: 132, y: 3, width: UIScreen.main.bounds.size.width - (132 + 67), height: 30 - 3*2)
        img.frame = CGRect(x: UIScreen.main.bounds.size.width - 15 - 77, y: (30 - 15)/2, width: 15, height: 15)
        titleLabel.frame = CGRect(x: 35, y: 0, width: 150, height: 30)
        valueLabel.frame = CGRect(x: 152, y: 0, width: 150, height: 30)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fc_addTarget(target: self, action: #selector(FC_SelectDepartmentView.clickSelfView))
        
        addSubview(starsLb)
        addSubview(borderView)
        addSubview(img)
        addSubview(titleLabel)
        addSubview(valueLabel)
    }
    
    @objc func clickSelfView() {
        if didSelectBlock != nil {
            didSelectBlock?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
