//
//  FC_RetrievePaswdViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/11.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxCocoa
import RxSwift

class FC_RetrievePaswdViewController: UIViewController {

    @IBOutlet weak var accountTextField: HoshiTextField!
    @IBOutlet weak var getCodeBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

extension FC_RetrievePaswdViewController {
    
    fileprivate func setupUI() {
        setupTextField(textfield: accountTextField)
  
        // 设置圆角
        getCodeBut.fc_corner(byRoundingCorners: [.allCorners], radii: 5)
        
        // 获取验证码
        getCodeBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            let accountStr = self?.accountTextField.text ?? ""
            if !accountStr.isPhone {
                FC_HUD.showInfo(withStatus: "手机号码有误")
            }else {
                DLog("获取验证码")
                
                FC_NetProvider.shared.sendMsg(phone: self?.accountTextField.text! ?? "", type: MsgType.Msg_ChangePaswd.rawValue, success: { (results) in
                    
                    let isSuc:Int = results["data"] as! Int
                    if isSuc == 1 {
                        self?.getCodeBut.sendCodeBut(totalTime: 59, duringText: " 秒后重新获取验证码", duringColor: Sub_666666_Color, againText: "重新获取验证码", againColor: Theme_4B77F6_Blue)
                    }else {
                        FC_HUD.fc_showInfo("连接异常，请稍后重试")
                    }
                    
                }, failure: { (error) in
                    
                })
                
            }
            
        }).disposed(by: disposeBag)
        
        // 校验输入内容
        accountTextField.rx.text.orEmpty
            .map { $0.count == 11 }
            .share(replay: 1)
            .subscribe(onNext: {[weak self] (bool) in
                self?.getCodeBut.isEnabled = bool
                self?.getCodeBut.backgroundColor = bool == true ? Theme_4B77F6_Blue : Grey_95B3F9_Blue
                }, onError: { (error) in }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupTextField(textfield: HoshiTextField) -> () {
        textfield.placeholderColor = Content_999999_Color
        textfield.borderActiveColor = Theme_4B77F6_Blue
        textfield.borderInactiveColor = HexColor(0xe5e5e5)
        textfield.placeholderFontScale = 0.8
        textfield.tintColor = Theme_4B77F6_Blue
    }
}
