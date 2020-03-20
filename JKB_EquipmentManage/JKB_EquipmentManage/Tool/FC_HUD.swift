//
//  FC_HUD.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/5.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import SVProgressHUD


class FC_HUD: SVProgressHUD {

    override init(frame: CGRect) {
        super.init(frame: frame)
        minimumDismissTimeInterval = 2.0
        defaultMaskType = .black
        defaultStyle = .dark
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 无文字，加载提示框
    class func fc_show() {
        let offset : UIOffset = UIOffsetMake(0, 10)
        FC_HUD.self.setOffsetFromCenter(offset)
        FC_HUD.self.setDefaultStyle(SVProgressHUDStyle.dark)
        FC_HUD.show()
    }
    
    /// 加载图片+文字（图片是固定图片）
    /// - Parameter status: 提示信息
    class func fc_showImgText(_ status:String) {
        FC_HUD.self.resetOffsetFromCenter()
        FC_HUD.self.setDefaultStyle(SVProgressHUDStyle.light)
        FC_HUD.self.setBackgroundColor(UIColor.white)
        FC_HUD.self.setDefaultMaskType(.black)
        FC_HUD.setImageViewSize(CGSize(width: 64, height: 64))
        FC_HUD.setMinimumSize(CGSize(width: 140, height: 66))
        FC_HUD.show(imageNamed("home_icn_fuc_check")!, status: status)
        FC_HUD.setMinimumDismissTimeInterval(2.0)
    }
    
    /// 带图片Toast提示框
    /// - Parameter status: 提示信息
    class func fc_showInfo(_ status:String) {
        FC_HUD.self.resetOffsetFromCenter()
        FC_HUD.self.setDefaultStyle(SVProgressHUDStyle.dark)
        FC_HUD.showInfo(withStatus: status)
    }
    
    /// 纯文字Toast提示框
    /// - Parameters:
    ///   - info: 提示信息
    ///   - viewController: 提示父视图
    ///   - duration: 显示时间，默认2s
    ///   - position: 显示位置，默认中心显示
    class func fc_toastInfo(_ info:String,_ viewController:UIViewController,duration:TimeInterval = 2.0,position:ToastPosition = .center) {
        viewController.view.makeToast(info, duration: duration, position: position)
    }
    
    /// 成功提示框
    /// - Parameter status: 提示信息
    class func fc_showSuccess(_ status:String) {
        FC_HUD.self.resetOffsetFromCenter()
        FC_HUD.self.setDefaultStyle(SVProgressHUDStyle.dark)
        FC_HUD.showSuccess(withStatus: status)
    }
    
    /// 错误提示框
    /// - Parameter status: 提示信息
    class func fc_showError(_ status:String) {
        FC_HUD.self.resetOffsetFromCenter()
        FC_HUD.self.setDefaultStyle(SVProgressHUDStyle.dark)
        FC_HUD.showError(withStatus: status)
    }
    
    
    /// 显示旋转等待
    /// - Parameter status: 等待信息
    class func fc_withStatus(_ status:String) {
        FC_HUD.self.resetOffsetFromCenter()
        FC_HUD.self.setDefaultStyle(SVProgressHUDStyle.dark)
        FC_HUD.show(withStatus: status)
    }
    
    /// 隐藏
    class func fc_dismiss() {
        FC_HUD.dismiss()
    }
}
