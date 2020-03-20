//
//  FC_Button.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

public class FC_Button: UIButton {

    public enum TitleTextType:Int {
        case TopImage_BottomText //上图,下文
        case TopText_BottomImage //上文,下图
        case LeftImage_RightText //左图,右文
        case LeftText_RightImage //左文,右图
    }
    
    /// 图片大小
    var imageSize: CGSize?
    /// 间距大小
    var space: CGFloat?
    /// 按钮显示类型
    var titleTextType: TitleTextType?
    
    /// 初始化but
    ///
    /// - Parameters:
    ///   - frame: 位置
    ///   - type: but类型
    ///   - imageSize: 图片大小
    ///   - space: 文图间距大小
    ///   - titleTextType: 显示风格
    init?(frame: CGRect, type: UIButtonType, imageSize: CGSize, space: CGFloat, titleTextType: TitleTextType) {
        super.init(frame: frame)
        self.init(type: type)
        self.imageSize = imageSize
        self.space = space
        self.titleTextType = titleTextType
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 重写布局
    override open func layoutSubviews() {
        super.layoutSubviews()
        // 文字自适应
        self.titleLabel?.sizeToFit()
        
        if self.titleTextType == .TopImage_BottomText {
            self.titleLabel?.textAlignment = .center
            let textH = self.titleLabel?.text?.fc_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: self.frame.width, height:CGFloat(MAXFLOAT))).height
            let margin = (self.frame.height-(self.imageSize?.height)!-self.space!-textH!)/2
            
            self.imageView?.frame = CGRect(x: (self.frame.width-(self.imageSize?.width)!)/2, y: margin, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
            self.titleLabel?.frame = CGRect(x: 0, y: (self.imageView?.frame.maxY)!+self.space!, width: self.frame.width, height: textH!)
        }
        
        if self.titleTextType == .TopText_BottomImage {
            self.titleLabel?.textAlignment = .center
            let textH = self.titleLabel?.text?.fc_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: self.frame.width, height:CGFloat(MAXFLOAT))).height
            let margin = (self.frame.height-(self.imageSize?.height)!-self.space!-textH!)/2
            self.titleLabel?.frame = CGRect(x: 0, y: margin, width: self.frame.width, height: textH!)
            self.imageView?.frame = CGRect(x: (self.frame.width-(self.imageSize?.width)!)/2, y: (self.titleLabel?.frame.maxY)!+self.space!, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
        }
        
        if self.titleTextType == .LeftImage_RightText {
            let textW = self.titleLabel?.text?.fc_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: CGFloat(MAXFLOAT), height:self.frame.height)).width
            let margin = (self.frame.width-(self.imageSize?.width)!-self.space!-textW!)/2
            self.imageView?.frame = CGRect(x: margin, y: (self.frame.height-(self.imageSize?.height)!)/2, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
            self.titleLabel?.frame = CGRect(x: (self.imageView?.frame.maxX)!+self.space!, y:0, width: textW!, height: self.frame.height)
        }
        
        if self.titleTextType == .LeftText_RightImage {
            let textW = self.titleLabel?.text?.fc_widthForComment(font:(self.titleLabel?.font)!, size: CGSize(width: CGFloat(MAXFLOAT), height:self.frame.height)).width
            let margin = (self.frame.width-(self.imageSize?.width)!-self.space!-textW!)/2
            self.titleLabel?.frame = CGRect(x: margin, y:0, width: textW!, height: self.frame.height)
            self.imageView?.frame = CGRect(x: (self.titleLabel?.frame.maxX)!+self.space!, y: (self.frame.height-(self.imageSize?.height)!)/2, width: (self.imageSize?.width)!, height: (self.imageSize?.height)!)
        }
    }
}

extension String {
    func fc_widthForComment(font: UIFont, size: CGSize) -> CGSize {
        let rect = NSString(string: self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return rect.size
    }
}
