//
//  FC_SetPaswdViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/9.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxCocoa
import RxSwift

class FC_SetPaswdViewController: UIViewController {

    // 用户信息
    var infoDic: [String:String]?
    
    @IBOutlet weak var paswdTextField: HoshiTextField!
    @IBOutlet weak var confirmTextField: HoshiTextField!
    @IBOutlet weak var submitBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

extension FC_SetPaswdViewController {
    
    fileprivate func setupUI() {
        setupTextField(textfield: paswdTextField)
        setupTextField(textfield: confirmTextField)
        
        // 设置圆角
        submitBut.fc_corner(byRoundingCorners: [.allCorners], radii: 5)
        // 确认提交
        submitBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            let paswdStr = self?.paswdTextField.text ?? ""
            let confirmStr = self?.confirmTextField.text ?? ""
            
            if !paswdStr.is8_32Paswd {
                FC_HUD.showInfo(withStatus: "第一次密码有误")
            }else if !confirmStr.is8_32Paswd {
                FC_HUD.showInfo(withStatus: "第二次密码有误")
            }else {
                
                FC_NetProvider.shared.reg(username: self?.infoDic!["name"] ?? "", password: self?.paswdTextField.text! ?? "", ensurePassword: self?.confirmTextField.text! ?? "", phone: self?.infoDic!["phone"] ?? "", company: self?.infoDic!["company"] ?? "", success: { (results) in
                    
                    let res: Int = results["result"] as! Int
                    if res == 1 {
                        let isSuc:Int = results["data"] as! Int
                        if isSuc == 1 {
                            FC_HUD.fc_showSuccess("注册成功")
                            FC_DispatchAfter(after: 2.0, handler: {
                                self?.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
                    }else {
                        let isMsg = results.keys.contains("message")
                        if isMsg == true {
                            FC_HUD.fc_showInfo(results["message"] as! String)
                        }
                    }
            
                }, failure: { (_) in
                    
                })
            }
        }).disposed(by: disposeBag)
        
        // 校验输入内容
        let paswdText = paswdTextField.rx.text.orEmpty.map { $0.count > 5 && $0.count < 18 }.share(replay: 1)
        let confirmText = confirmTextField.rx.text.orEmpty.map { $0.count > 5 && $0.count < 18 }.share(replay: 1)
        
        Observable
            .combineLatest(paswdText, confirmText) {$0 && $1}
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
    
    fileprivate func setupTextField(textfield: HoshiTextField) -> () {
        textfield.placeholderColor = Content_999999_Color
        textfield.borderActiveColor = Theme_4B77F6_Blue
        textfield.borderInactiveColor = HexColor(0xe5e5e5)
        textfield.placeholderFontScale = 0.8
        textfield.tintColor = Theme_4B77F6_Blue
    }
}
