//
//  FC_TitleView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/7/31.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import SnapKit

class FC_TitleView: UIView {

    
    /// 搜索框占位文字
    var placeholder: String? {
        didSet{
            searchBar.placeholder = placeholder
        }
    }
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.barTintColor = .white
        searchBar.layer.borderColor = Line_e0e0e0_Gray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.masksToBounds = true
        searchBar.layer.cornerRadius = 5
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.width.equalTo(self.width - 20)
            make.height.equalTo(35)
        }
    }
    
}

extension FC_TitleView {
    
    fileprivate func setupUI() {
        addSubview(searchBar)
        
        
    }
    
}
