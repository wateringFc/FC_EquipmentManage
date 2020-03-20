//
//  FC_CodeView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/10.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

protocol FC_CodeViewDelegate {
    /// 验证码输入完成后的操作
    ///
    /// - Parameters:
    ///   - codeView: 验证码视图
    ///   - code: 输入后的验证码
    func codeDidFinishedInput(codeView:FC_CodeView, code:String)
}

class FC_CodeView: UIView {
    
    /// 代理
    var delegate: FC_CodeViewDelegate?
    /// 输入框数组
    var textfieldArr = [UITextField]()
    /// 框框之间的间隔
    var margin:CGFloat = 0
    /// 输入框宽度
    let textFieldW:CGFloat = 40
    /// 个数
    var num = 0
    
    /// 构造函数
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - number: 个数
    ///   - margin: 间距
    init(frame: CGRect,number:Int, margins:CGFloat) {
        super.init(frame: frame)
        num = number
        margin = margins
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 清空输入框
    func cleanVerificationCodeView(){
        for tv in textfieldArr {
            tv.text = ""
        }
        // 第一个输入框成为第一响应者
        textfieldArr.first?.becomeFirstResponder()
    }
}

extension FC_CodeView {
    
    fileprivate func setupUI(){
        // 不允许用户直接操作验证码框
        self.isUserInteractionEnabled = false
//        // 计算左间距
//        let leftmargin = (UIScreen.main.bounds.width - textFieldW * CGFloat(num) - CGFloat(num - 1) * margin) / 2
        // 创建TextFiedl及横线
        for i in 0..<num {
            let rect = CGRect(x: 0 + CGFloat(i)*textFieldW + CGFloat(i)*margin, y: 0, width: textFieldW, height: textFieldW)
            let tv = createTextField(frame: rect)
            tv.tag = i
            textfieldArr.append(tv)
            // 底部横线
            let lineView = UIView(frame: CGRect(x: 0 + CGFloat(i)*textFieldW + CGFloat(i)*margin, y: textFieldW, width: textFieldW, height: 2))
            lineView.backgroundColor = Normal_000000_Color
            addSubview(lineView)
        }
        // 容错处理
        if num < 1 { return }
        // 第一个成为响应者
        textfieldArr.first?.becomeFirstResponder()
    }
    
    private func createTextField(frame:CGRect)->UITextField{
        let tv = FC_CodeTextField(frame: frame)
        tv.borderStyle = .none
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 25)
        tv.textColor = Main_222222_Color
        tv.delegate = self
        tv.fc_delegate = self
        addSubview(tv)
        tv.keyboardType = .numberPad
        return tv
    }
}

extension FC_CodeView: UITextFieldDelegate, FC_CodeTextFieldDelegate{
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !textField.hasText {
            // tag 对应数组下标
            let index = textField.tag
            textField.resignFirstResponder()
            if index == num - 1 {
                textfieldArr[index].text = string
                // 拼接结果
                var code = ""
                for tv in textfieldArr {
                    code += tv.text ?? ""
                }
                delegate?.codeDidFinishedInput(codeView: self, code: code)
                return false
            }
            
            textfieldArr[index].text = string
            textfieldArr[index + 1].becomeFirstResponder()
        }
        return false
    }
    
    /// 监听键盘删除键
    func didClickBackWard() {
        for i in 1..<num{
            if !textfieldArr[i].isFirstResponder { continue }
            textfieldArr[i].resignFirstResponder()
            textfieldArr[i-1].becomeFirstResponder()
            textfieldArr[i-1].text = ""
        }
    }
}
