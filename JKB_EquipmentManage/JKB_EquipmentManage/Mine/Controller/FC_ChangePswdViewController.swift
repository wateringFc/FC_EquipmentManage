//
//  FC_ChangePswdViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/29.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxCocoa
import RxSwift


class FC_ChangePswdViewController: UIViewController {

    /// 手机号
    @IBOutlet weak var phoneLb: UILabel!
    /// 获取验证码
    @IBOutlet weak var getCodeBut: UIButton!
    /// 验证码输入框
    @IBOutlet weak var codeFd: HoshiTextField!
    /// 新密码输入框
    @IBOutlet weak var newPswdFd: HoshiTextField!
    /// 确认新密码输入框
    @IBOutlet weak var newPswdFd1: HoshiTextField!
    /// 提交
    @IBOutlet weak var submitBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        butsAction()
        
    }
}

extension FC_ChangePswdViewController {
    
    fileprivate func setupUI() {
        setupTextField(textfield: codeFd)
        setupTextField(textfield: newPswdFd)
        setupTextField(textfield: newPswdFd1)
        submitBut.fc_corner(byRoundingCorners: [.allCorners], radii: 5)
        
        getCodeBut.layer.masksToBounds = true
        getCodeBut.layer.cornerRadius = 5
        getCodeBut.layer.borderColor = Line_e0e0e0_Gray.cgColor
        getCodeBut.layer.borderWidth = 1
    }
    
    /// 设置textfield
    fileprivate func setupTextField(textfield: HoshiTextField) -> () {
        textfield.placeholderColor = Content_999999_Color
        textfield.borderActiveColor = Theme_4B77F6_Blue
        textfield.borderInactiveColor = HexColor(0xe5e5e5)
        textfield.placeholderFontScale = 0.8
        textfield.tintColor = Theme_4B77F6_Blue
    }
    
    fileprivate func butsAction() {
        // 获取验证码
        getCodeBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            self?.getCodeBut.sendCodeBut(totalTime: 59, duringText: "s", duringColor: Sub_666666_Color, againText: "重新获取", againColor: Theme_4B77F6_Blue)
            
        }).disposed(by: disposeBag)
        
        // 提交
        submitBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            
            let codeStr = self?.codeFd.text ?? ""
            let pswdStr = self?.newPswdFd.text ?? ""
            let pswdStr1 = self?.newPswdFd1.text ?? ""
            if !pswdStr.is8_32Paswd {
                FC_HUD.fc_showInfo("请检查新密码是否符合要求")
                
            }else if !pswdStr1.is8_32Paswd {
                FC_HUD.fc_showInfo("请检查新密码是否符合要求")
                
            }else if pswdStr != pswdStr1 {
                FC_HUD.fc_showInfo("请检查两次密码是否一致")
                
            }else if !codeStr.isCode {
                FC_HUD.fc_showInfo("请检查验证码是否正确")
                
            }else {
                self?.view.endEditing(true)
                DLog("提交")
            }
            
        }).disposed(by: disposeBag)
        
        
        // 校验输入内容
        let codeText = codeFd.rx.text.orEmpty.map { $0.count == 4 }.share(replay: 1)
        let pswdText = newPswdFd.rx.text.orEmpty.map { $0.count > 5 && $0.count < 18 }.share(replay: 1)
        let pswdText1 = newPswdFd1.rx.text.orEmpty.map { $0.count > 5 && $0.count < 18 }.share(replay: 1)
        
        Observable
            .combineLatest(codeText, pswdText, pswdText1) {$0 && $1 && $2}
            .share(replay: 1)
            .subscribe(onNext: {[weak self] (bool) in
                // 修改按钮是否可以点击
                self?.submitBut.isEnabled = bool
                // 修改按钮背景色
                self?.submitBut.backgroundColor = bool == true ? Theme_4B77F6_Blue : Grey_95B3F9_Blue
                }, onError: { (error) in
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
