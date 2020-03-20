//
//  FC_CreateView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/16.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_CreateView: NSObject {
    
    /// 控件默认尺寸
    class func getDefaultFrame() -> CGRect {
        let defaultFrame = CGRect(x:0, y:0, width:100, height:30)
        return defaultFrame
    }
    
    /// 创建按钮
    class func createButton(rect:CGRect = FC_CreateView.getDefaultFrame(), title: String, textColor: UIColor = UIColor.black, backgroundColor:UIColor = UIColor.white, font: UIFont = UIFont.systemFont(ofSize: 15), action: Selector, sender: UIViewController)
        -> UIButton {
            let button = UIButton(frame:rect)
            button.backgroundColor = backgroundColor
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel!.font = font
            button.addTarget(sender, action:action, for:.touchUpInside)
            return button
    }
    
    /// 创建文本输入框控件
    class func createTextField(rect:CGRect = FC_CreateView.getDefaultFrame(), placeHolder: String, sender: UITextFieldDelegate)
        -> UITextField
    {
        let textField = UITextField(frame:rect)
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.black
        textField.placeholder = placeHolder
        textField.borderStyle = UITextBorderStyle.roundedRect
        //        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = sender
        return textField
    }
    
    /// 创建分段单选控件
    class func createSegment(items: [String], action:Selector, sender:UIViewController)
        ->UISegmentedControl
    {
        let segment = UISegmentedControl(items:items)
        segment.frame = FC_CreateView.getDefaultFrame()
        //segment.segmentedControlStyle = UISegmentedControlStyle.Bordered
        segment.isMomentary = false
        segment.addTarget(sender, action:action, for:.valueChanged)
        return segment
    }
    
    /// 创建文本标签控件
    class func createLabel(rect:CGRect = FC_CreateView.getDefaultFrame(),title:String, textColor:UIColor = UIColor.black, bgColor:UIColor = UIColor.white, font:UIFont = UIFont.systemFont(ofSize: 15), alignment:NSTextAlignment = .left) -> UILabel
    {
        let label = UILabel.init(frame: rect)
        label.backgroundColor = bgColor
        label.textColor = textColor
        label.text = title;
        label.font =  font
        label.textAlignment = alignment
        return label
    }
    
    /// 创建图片控件
    class func createImgView(rect:CGRect = FC_CreateView.getDefaultFrame(),imgName:String,contentMode:UIViewContentMode = .scaleToFill) -> UIImageView
    {
        let imgView:UIImageView = UIImageView.init(frame: CGRect.zero)
        imgView.contentMode = contentMode
        if let image = UIImage.init(named: imgName) {
            imgView.image = image
        }
        return imgView
    }
}

