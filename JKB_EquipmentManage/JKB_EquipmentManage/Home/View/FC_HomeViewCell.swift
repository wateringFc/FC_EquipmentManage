//
//  FC_HomeViewCell.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/7.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import SnapKit

class FC_HomeViewCell: UITableViewCell {

    fileprivate lazy var icon: UIImageView = UIImageView()
    
    fileprivate lazy var subIcon: UIImageView = {
        let subIcon = UIImageView(image: UIImage(named: "home_icn_eye"))
        return subIcon
    }()
    
    fileprivate lazy var titleLb: UILabel = {
        let titleLb = UILabel()
        titleLb.textColor = Normal_000000_Color
        titleLb.text = "新款的超声检测仪维修注意事项"
        titleLb.font = TextStyleFont("PingFang SC", 13)
        return titleLb
    }()
    
    fileprivate lazy var readingLb: UILabel = {
        let readingLb = UILabel()
        readingLb.textColor = Normal_000000_Color
        readingLb.text = "66666"
        readingLb.font = TextStyleFont("PingFang SC", 11)
        readingLb.alpha = 0.65
        return readingLb
    }()
    
    fileprivate lazy var dateLb: UILabel = {
        let dateLb = UILabel()
        dateLb.textColor = Normal_000000_Color
        dateLb.text = "3.20"
        dateLb.font = TextStyleFont("PingFang SC", 11)
        dateLb.alpha = 0.65
        return dateLb
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension FC_HomeViewCell {
    
    fileprivate func setupUI() {
        icon.image = UIImage(named: "home_placeholder")
        
        contentView.addSubview(icon)
        contentView.addSubview(subIcon)
        contentView.addSubview(titleLb)
        contentView.addSubview(readingLb)
        contentView.addSubview(dateLb)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(icon.snp.top)
            make.width.equalTo(kScreenW - 100)
        }

        subIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(15)
        }

        readingLb.snp.makeConstraints { (make) in
            make.left.equalTo(subIcon.snp.right).offset(8)
            make.centerY.equalTo(subIcon.snp.centerY)
        }

        dateLb.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(subIcon.snp.centerY)
        }
    }
}
