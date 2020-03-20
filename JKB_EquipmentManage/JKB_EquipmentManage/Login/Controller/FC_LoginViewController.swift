//
//  FC_LoginViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/8.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxCocoa
import RxSwift
import Alamofire
import SwiftyJSON

class FC_LoginViewController: UIViewController {

    @IBOutlet weak var closeBut: UIButton!
    @IBOutlet weak var loginBut: UIButton!
    @IBOutlet weak var regBut: UIButton!
    @IBOutlet weak var forgotPaswdBut: UIButton!
    @IBOutlet weak var eyesBut: UIButton!
    
    @IBOutlet weak var nameTextfield: HoshiTextField!
    @IBOutlet weak var paswdTextfield: HoshiTextField!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        butsAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
   
}

extension FC_LoginViewController {
    
    fileprivate func setupUI() {
        setupTextField(textfield: nameTextfield, isPaswd: false)
        setupTextField(textfield: paswdTextfield, isPaswd: true)
        eyesBut.isSelected = false
        // 设置圆角
        loginBut.fc_corner(byRoundingCorners: [.allCorners], radii: 5)    
    }
    
    fileprivate func setupTextField(textfield: HoshiTextField, isPaswd: Bool) -> () {
        textfield.placeholderColor = Content_999999_Color
        textfield.borderActiveColor = Theme_4B77F6_Blue
        textfield.borderInactiveColor = HexColor(0xe5e5e5)
        textfield.placeholderFontScale = 0.8
        textfield.tintColor = Theme_4B77F6_Blue
        if isPaswd {textfield.isSecureTextEntry = true}
    }
    
    fileprivate func butsAction() {
        // 关闭
        closeBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        // 忘记密码
        forgotPaswdBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { () in
            DLog("忘记密码")
            let vc = FC_RetrievePaswdViewController()
            vc.title = "找回登录密码"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        
        // 注册
        regBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            let vc = FC_FC_RegInfoViewController()
            vc.title = "注册"
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        
        // 登录
        loginBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            
            let phoneStr = self?.nameTextfield.text ?? ""
            let paswdStr = self?.paswdTextfield.text ?? ""
            if phoneStr.count < 1 {
                FC_HUD.fc_showInfo("请检查用户名是否正确")
            }else if !paswdStr.is8_32Paswd {
                FC_HUD.fc_showInfo("请检查密码是否正确")
            }else {
                DLog("登录")
                
                FC_NetProvider.shared.login(userName: self?.nameTextfield.text! ?? "", paswd: self?.paswdTextfield.text! ?? "", success: { (results) in
                    // 1、删除数据库中内容
                    FC_SQLiteManager.manager.delete(id: 100)
                    
                    // 2、插入token到本地数据库中
                    var info = FC_UserInfo()
                    let str = results["data"] as! String
                    info.token = "Bearer " + str
                    FC_SQLiteManager.manager.insert(info)

                    FC_HUD.fc_showSuccess("登录成功")
                    
                    /// 3、异步获取用户信息并存储
                    FC_NetProvider.shared.userInfo(success: { (res) in
                        var info = FC_UserInfo()
                        let data:NSDictionary = res["data"] as! NSDictionary
                        info.name = data["username"] as! String
                        info.phone = data["phone"] as! String
                        info.company = data["companyName"] as! String
                        FC_SQLiteManager.manager.update(id: 1, keyWord: "n_p_c", newsInfo: info)
                        
                    }) { (_) in }
                    
                }, failure: { (error) in

                })
            }
            
        }).disposed(by: disposeBag)
        
        // 校验输入内容
        let nameText = nameTextfield.rx.text.orEmpty.map { $0.count > 1 }.share(replay: 1)
        let paswdText = paswdTextfield.rx.text.orEmpty.map { $0.count > 7 && $0.count < 32 }.share(replay: 1)
        
        Observable
            .combineLatest(nameText, paswdText) {$0 && $1}
            .share(replay: 1)
            .subscribe(onNext: {[weak self] (bool) in
                // 修改按钮是否可以点击
                self?.loginBut.isEnabled = bool
                // 修改按钮背景色
                self?.loginBut.backgroundColor = bool == true ? Theme_4B77F6_Blue : Grey_95B3F9_Blue
                }, onError: { (error) in
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    @IBAction func clickEyesBut(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            paswdTextfield.isSecureTextEntry = false
        }else {
            paswdTextfield.isSecureTextEntry = true
        }
    }
    
}
