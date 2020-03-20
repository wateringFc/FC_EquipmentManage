//
//  FC_ChangePhoneViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/29.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxCocoa
import RxSwift

class FC_ChangePhoneViewController: UIViewController {
    
    /// 手机号码
    @IBOutlet weak var phoneLb: UILabel!
    /// 手机号输入框
    @IBOutlet weak var phoneFd: HoshiTextField!
    /// 验证码输入框
    @IBOutlet weak var codeFd: HoshiTextField!
    /// 获取验证码
    @IBOutlet weak var getCodeBut: UIButton!
    /// 确定
    @IBOutlet weak var determineBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        butsAction()
    }
}


extension FC_ChangePhoneViewController {
    
    fileprivate func setupUI() {
        
        setupTextField(textfield: phoneFd)
        setupTextField(textfield: codeFd)
        determineBut.fc_corner(byRoundingCorners: [.allCorners], radii: 5)
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
        
        // 确定
        determineBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            
            let phoneStr = self?.phoneFd.text ?? ""
            let codeStr = self?.codeFd.text ?? ""
            if !phoneStr.isPhone {
                FC_HUD.fc_showInfo("请检查手机号是否正确")
            }else if !codeStr.isCode {
                FC_HUD.fc_showInfo("请检查验证码是否正确")
            }else {
                self?.view.endEditing(true)
                DLog("登录")
            }
            
        }).disposed(by: disposeBag)
        
        
        // 校验输入内容
        let phoneText = phoneFd.rx.text.orEmpty.map { $0.count == 11 }.share(replay: 1)
        let codeText = codeFd.rx.text.orEmpty.map { $0.count == 4 }.share(replay: 1)
        
        Observable
            .combineLatest(phoneText, codeText) {$0 && $1}
            .share(replay: 1)
            .subscribe(onNext: {[weak self] (bool) in
                // 修改按钮是否可以点击
                self?.determineBut.isEnabled = bool
                // 修改按钮背景色
                self?.determineBut.backgroundColor = bool == true ? Theme_4B77F6_Blue : Grey_95B3F9_Blue
                }, onError: { (error) in
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
