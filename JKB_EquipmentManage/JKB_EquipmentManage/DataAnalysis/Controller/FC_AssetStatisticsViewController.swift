//
//  FC_AssetStatisticsViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/22.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_AssetStatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        sutupUI()
        
    }
}

extension FC_AssetStatisticsViewController {
    
    fileprivate func sutupUI() {
        view.backgroundColor = Bg_f5f5f5
        addPieView()
    }
    
    /// 添加饼图
    fileprivate func addPieView() {
        
        let topView = addtitleView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenW, height: 70), titleStr: "全部资产分布情况", valueStr: "共 1048 台")
        view.addSubview(topView)
        
        let data1:[CGFloat] = [1 , 1.5, 2.5, 2, 3]
        let color1 = [HexColor(0xE8B660),
                     HexColor(0xE1517D),
                     HexColor(0xF3EA9D),
                     HexColor(0x67B8CF),
                     HexColor(0xA16ADF)]
        let upText1 = ["68台，20%", "68台，35%", "68台，15%", "68台，18%", "68台，20%"]
        let downText1 = ["心血管科", "骨伤科", "内科", "外科", "耳鼻喉科"]
        
        let h = (kScreenH - 140 - 20 - kNavBarHeight - kSafeBottomAreaH)/2
        let pieView1 = FCPieView(frame: CGRect(x: 0, y: kNavBarHeight + topView.height, width: view.width, height: h), datas: data1, colors: color1, upTexts: upText1, downTexts: downText1, middle:"分布")
        pieView1.upTextColor = Normal_000000_Color
        pieView1.bottomTextColor = Content_999999_Color
        view.addSubview(pieView1)
        
        
        let topView2 = addtitleView(frame: CGRect(x: 0, y: 10 + pieView1.y + pieView1.height, width: kScreenW, height: 70), titleStr: "全部资产价值情况", valueStr: "共 26598.35 万")
        view.addSubview(topView2)
        
        let data2:[CGFloat] = [1 , 1.5, 2.5, 0.5, 2, 2.5, 2, 0.5]
        let color2 = [HexColor(0xE8B660),
                     HexColor(0xF3EA9D),
                     HexColor(0xC1D16C),
                     HexColor(0xE1517D),
                     HexColor(0x67B165),
                     HexColor(0x67B8CF),
                     HexColor(0x418CE2),
                     HexColor(0xF3EA7D)]
        let upText2 = ["20%", "22%", "33%", "44%", "55%", "66%", "77%", "88%"]
        let downText2 = ["0~10万(68台)", "50~100万(68台)", "4~15万(68台)", "99~85万(68台)", "1000~500万(68台)", "45~100万(68台)", "96~100万(68台)", "0~10万(68台)"]
        let pieView2 = FCPieView(frame: CGRect(x: 0, y:topView2.y + topView2.height , width: view.width, height: h), datas: data2, colors: color2, upTexts: upText2, downTexts: downText2, middle:"价值")
        pieView2.upTextColor = Normal_000000_Color
        pieView2.bottomTextColor = Content_999999_Color
        view.addSubview(pieView2)
    }
    
    /// 设置标题
    fileprivate func addtitleView(frame: CGRect, titleStr: String, valueStr: String) -> (UIView) {
        let bgView = UIView(frame: frame)
        bgView.backgroundColor = .white
        view.addSubview(bgView)
        
        let titleLb = UILabel(frame: CGRect(x: 20, y: 0, width: bgView.width/2 - 20, height: bgView.height))
        titleLb.text = titleStr
        titleLb.textColor = Main_222222_Color
        titleLb.font = UIFont.systemFont(ofSize: 14)
        bgView.addSubview(titleLb)
        
        let valueLb = UILabel(frame: CGRect(x: bgView.width/2, y: 0, width: bgView.width/2 - 20, height: bgView.height))
        valueLb.textColor = Normal_000000_Color
        valueLb.font = UIFont.boldSystemFont(ofSize: 19)
        valueLb.textAlignment = .right
        
        // 设置头尾 颜色、字体
        let attrStr = NSMutableAttributedString.init(string: valueStr)
        attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value:Normal_000000_Color, range:NSRange.init(location:0, length: 1))
        attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value:Normal_000000_Color, range:NSRange.init(location:valueStr.count - 1, length: 1))
        attrStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: NSRange.init(location:0, length: 1))
        attrStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: NSRange.init(location:valueStr.count - 1, length: 1))
       
        valueLb.attributedText = attrStr
        bgView.addSubview(valueLb)
    
        return bgView
    }
    
    
    
}
