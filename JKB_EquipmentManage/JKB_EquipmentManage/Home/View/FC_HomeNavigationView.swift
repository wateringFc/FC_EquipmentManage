//
//  FC_HomeNavigationView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_HomeNavigationView: UIView {

    /// 扫一扫
    var didScanBut: (()->())?
    /// 维修扫描
    var didRepairBut: (()->())?
    /// 保养扫描
    var didNursingBut: (()->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FC_HomeNavigationView {
    
    fileprivate func setupUI() {
        
        backgroundColor = Theme_4B77F6_Blue
        
        var texts:[String] = ["扫一扫", "维修扫描", "保养扫描"]
        let imgs:[String] = ["home_icn_scan", "home_icn_rep", "home_icn_proscan"]
        let butW = ((kScreenW - 40) - 20*2)/3
        for i in 0..<texts.count {
            let button:FC_Button? = FC_Button.init(frame: CGRect.zero,
                                                   type: .custom,
                                                   imageSize: CGSize(width:32,height:32),
                                                   space: 8,
                                                   titleTextType: FC_Button.TitleTextType(rawValue: 0)!)
            button?.setTitle(texts[i], for: .normal)
            button?.setTitleColor(.white, for: .normal)
            button?.setImage(UIImage.init(named: imgs[i]), for: .normal)
            button?.frame = CGRect(x: 20 + 20*i + Int(butW)*i, y: 48, width: Int(butW), height: 60)
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button?.tag = 100+i
            button?.addTarget(self, action: #selector(clickButs(but:)), for: .touchUpInside)
            addSubview(button!)
        }
    }
    
    @objc func clickButs(but:UIButton) {
        switch but.tag {
        case 100:
            didScanBut?()
        case 101:
            didRepairBut?()
        case 102:
            didNursingBut?()
        default:
            break
        }
    }
}
