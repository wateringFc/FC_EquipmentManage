//
//  FC_RegViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/9.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import IQKeyboardManagerSwift

class FC_RegViewController: UIViewController {

    // 用户信息
    var infoDic: [String:String]?
    
    
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var codeBgView: UIView!
    @IBOutlet weak var getCodeBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DLog(infoDic)
        
        phoneLb.text = infoDic!["phone"]!.phoneToAsterisk()
        
        // 禁用键盘管理工具
        let keyboardManager: IQKeyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.shouldResignOnTouchOutside = false
        keyboardManager.enableAutoToolbar = false
        
        
        let codeView = FC_CodeView(frame: CGRect(x: 0, y: 0, width: codeBgView.width, height: codeBgView.height), number: 6, margins: (codeBgView.width - 6*40)/5 )
        codeView.delegate = self
        codeBgView.addSubview(codeView)
        
        // 获取验证码
        getCodeBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            
            FC_NetProvider.shared.sendMsg(phone: self?.infoDic!["phone"] ?? "", type: MsgType.Msg_Registered.rawValue, success: { (results) in
                
                let res: Int = results["result"] as! Int
                if res == 1 {
                    let isSuc:Int = results["data"] as! Int
                    if isSuc == 1 {
                        self?.getCodeBut.sendCodeBut(totalTime: 59, duringText: " 秒后重新获取验证码", duringColor: Sub_666666_Color, againText: "重新获取验证码", againColor: Theme_4B77F6_Blue)
                    }else {
                        FC_HUD.fc_showInfo("连接异常，请稍后重试")
                    }
                }
                
            }, failure: { (error) in
                
            })
            
            
        }).disposed(by: disposeBag)
    }
}

extension FC_RegViewController: FC_CodeViewDelegate {
    
    func codeDidFinishedInput(codeView: FC_CodeView, code: String) {
        
        // 验证短信
        FC_NetProvider.shared.msgVerify(phone: infoDic!["phone"] ?? "", msgCode: code, type: MsgType.Msg_Registered.rawValue, success: { (results) in
            
            let res: Int = results["result"] as! Int
            if res == 1 {
                let isSuc:Int = results["data"] as! Int
                if isSuc == 1 {
                    // 如果输入正确
                    let vc = FC_SetPaswdViewController()
                    vc.title = "设置密码"
                    vc.infoDic = self.infoDic
                    self.navigationController?.pushViewController(vc, animated: false)
                }else {
                    FC_HUD.fc_showInfo("验证码输入错误")
                    // 清空输入框
                    codeView.cleanVerificationCodeView()
                }
            }
            
        }) { (_) in
            
        }
    }
}
