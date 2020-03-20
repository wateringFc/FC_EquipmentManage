//
//  FC_SetupNameViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/28.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_SetupNameViewController: UIViewController {

    var nameStr: String?
    /// 回调名字
    var blockNameStr: ((_ nameStr: String) -> Void)?
    
    fileprivate lazy var bgView:UIView = {
       let bgView = UIView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenW, height: 55))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    fileprivate lazy var textFd: UITextField = {
        let textFd = UITextField(frame: CGRect(x: 15, y: 0, width: kScreenW - 30, height: 55))
        textFd.clearsOnBeginEditing = true
        textFd.clearButtonMode = UITextFieldViewMode.whileEditing
        textFd.borderStyle = .none
        textFd.placeholder = "请输入名字"
        textFd.textColor = Normal_000000_Color
        return textFd
    }()
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: kNavBarHeight + 55 + 10, width: kScreenW-30, height: 20))
        label.text = "提示：输入本人真实姓名全称，便于审核。"
        label.textColor = Content_999999_Color
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension FC_SetupNameViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = Bg_f5f5f5
        view.addSubview(bgView)
        bgView.addSubview(textFd)
        view.addSubview(label)
        
        textFd.text = nameStr
        
        
        let rigItem = UIBarButtonItem().initItemWithTitle(title: "保存", color: Theme_4B77F6_Blue, font: UIFont.systemFont(ofSize: 16), target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = rigItem
    }
    
    @objc func save() {
        if !textFd.text!.isUserName {
            FC_HUD.fc_showError("名字有误")
        }else if textFd.text == nameStr {
            FC_HUD.fc_showInfo("名字未修改，无需保存")
        }else {
            view.endEditing(true)
            blockNameStr!(textFd.text!)
            FC_HUD.fc_showSuccess("保存成功")
            FC_DispatchAfter(after: 2.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
