//
//  FC_FC_RegInfoViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/9.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import TextFieldEffects
import RxCocoa
import RxSwift

class FC_FC_RegInfoViewController: UIViewController {

    /// 名字
    @IBOutlet weak var nameTextfield: HoshiTextField!
    /// 公司
    @IBOutlet weak var companyTextfield: HoshiTextField!
    /// 手机
    @IBOutlet weak var phoneTextfield: HoshiTextField!
    /// 获取按钮
    @IBOutlet weak var getcodeBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension FC_FC_RegInfoViewController {
    
    fileprivate func setupUI() {
        setupTextField(textfield: nameTextfield)
        setupTextField(textfield: companyTextfield)
        setupTextField(textfield: phoneTextfield)
        // 设置圆角
        getcodeBut.fc_corner(byRoundingCorners: [.allCorners], radii: 5)
        
        // 获取验证码
        getcodeBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            let nameStr = self?.nameTextfield.text ?? ""
            let companyStr = self?.companyTextfield.text ?? ""
            let phoneStr = self?.phoneTextfield.text ?? ""
            if !nameStr.isUserName {
                FC_HUD.showInfo(withStatus: "姓名有误")
            }else if !companyStr.isCompanyName {
                FC_HUD.showInfo(withStatus: "企业名称有误")
            }else if !phoneStr.isPhone {
                FC_HUD.showInfo(withStatus: "手机号码有误")
            }else {
                let vc = FC_RegViewController()
                vc.title = "注册"
                vc.infoDic = ["name":self!.nameTextfield.text!,
                              "company":self!.companyTextfield.text!,
                              "phone":self!.phoneTextfield.text!]
                self?.navigationController?.pushViewController(vc, animated: false)
            }
        }).disposed(by: disposeBag)
        
        // 校验输入内容
        let nameText = nameTextfield.rx.text.orEmpty.map { $0.count > 1 }.share(replay: 1)
        let companyText = companyTextfield.rx.text.orEmpty.map { $0.count > 2 }.share(replay: 1)
        let phoneText = phoneTextfield.rx.text.orEmpty.map { $0.count == 11}.share(replay: 1)
        
        Observable
            .combineLatest(nameText, companyText, phoneText) {$0 && $1 && $2}
            .share(replay: 1)
            .subscribe(onNext: {[weak self] (bool) in
                // 修改按钮是否可以点击
                self?.getcodeBut.isEnabled = bool
                // 修改按钮背景色
                self?.getcodeBut.backgroundColor = bool == true ? Theme_4B77F6_Blue : Grey_95B3F9_Blue
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
