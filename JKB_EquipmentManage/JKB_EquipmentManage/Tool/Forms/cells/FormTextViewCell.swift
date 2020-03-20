//
//  FormTextViewCell.swift
//  SwiftForms
//
//  Created by Joey Padot on 12/6/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormTextViewCell : FormBaseCell, UITextViewDelegate {
    
    // MARK: Cell views
    @objc public let titleLabel = UILabel()
    @objc public let textField  = UITextView()
    
    /// 字数限制
    fileprivate var maxNum:String?
    
    /// 显示输入字数
    fileprivate lazy var showTextLb:UILabel = {
        let showTextLb = UILabel()
        showTextLb.textColor = UIColor.lightGray
        showTextLb.font = UIFont.systemFont(ofSize: 11)
        showTextLb.textAlignment = .right
        return showTextLb
    }()
    
    // MARK: Properties
    fileprivate var customConstraints: [AnyObject]!
    
    // MARK: Class Funcs
    
    open override class func formRowCellHeight() -> CGFloat {
        return 120.0
    }
    
    // MARK: FormBaseCell
    
    open override func configure() {
        super.configure()
        
        selectionStyle = .none
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        textField.font = UIFont.systemFont(ofSize: 12)

        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(showTextLb)
        
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.textColor = UIColor.gray
        
        titleLabel.frame = CGRect(x: 35, y: 5, width: 300, height: 20)
        textField.frame = CGRect(x: 35, y: 30, width: UIScreen.main.bounds.size.width - 35*2, height: 120-40)
        showTextLb.frame = CGRect(x: 35, y: 120-30, width: UIScreen.main.bounds.size.width - 75, height: 15)
        
        textField.delegate = self
        
        
    }
    
    open override func update() {
        
        let str = rowDescriptor?.title
        
        let arr = str?.components(separatedBy: "：")
        maxNum = arr?[1]
        showTextLb.text = "\(textField.text.count)/" + maxNum!
        
        titleLabel.text = arr?[0] ?? "" + "："
        
        textField.text = rowDescriptor?.value as? String
        textField.isSecureTextEntry = false
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
        textField.keyboardType = .default
    }
    
    // MARK: UITextViewDelegate
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == rowDescriptor?.configuration.cell.placeholder {
            textField.text = ""
            textField.textColor = UIColor.gray
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count < 1 {
            textField.text = rowDescriptor?.configuration.cell.placeholder
            textField.textColor = UIColor.lightGray
        }
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        
        showTextLb.text = "\(textView.text.count)/\(maxNum!)"
        if textView.text.count >= Int(maxNum!)! {
            textView.text = String(textView.text.prefix(Int(maxNum!)!))
            showTextLb.text = "\(String(describing: maxNum))/\(String(describing: maxNum))"
            showTextLb.textColor = UIColor.red
            print("已经达到最大限制")
        }else {
            showTextLb.textColor = UIColor.lightGray
        }
        
        guard let text = textView.text , text.count > 0 else { rowDescriptor?.value = nil; update(); return }
        rowDescriptor?.value = text as AnyObject
        update()
    }
}



////
////  FormTextViewCell.swift
////  SwiftForms
////
////  Created by Joey Padot on 12/6/14.
////  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
////
//
//import UIKit
//
//open class FormTextViewCell : FormBaseCell, UITextViewDelegate {
//
//    // MARK: Cell views
//    @objc public let titleLabel = UILabel()
//    @objc public let textField  = UITextView()
//
//    // MARK: Properties
//    fileprivate var customConstraints: [AnyObject]!
//
//    // MARK: Class Funcs
//
//    open override class func formRowCellHeight() -> CGFloat {
//        return 110.0
//    }
//
//    // MARK: FormBaseCell
//
//    open override func configure() {
//        super.configure()
//
//        selectionStyle = .none
//
//        textField.backgroundColor = UIColor.yellow
//
//
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        textField.translatesAutoresizingMaskIntoConstraints = false
//
//        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
//        textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
//
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(textField)
//
//        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
//
//        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
//        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
//        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0))
//        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
//
//        textField.delegate = self
//    }
//
//    open override func update() {
//
//        titleLabel.text = rowDescriptor?.title
//        textField.text = rowDescriptor?.value as? String
//
//        textField.isSecureTextEntry = false
//        textField.autocorrectionType = .default
//        textField.autocapitalizationType = .sentences
//        textField.keyboardType = .default
//    }
//
//    open override func constraintsViews() -> [String : UIView] {
//        var views = ["titleLabel" : titleLabel, "textField" : textField]
//        if self.imageView!.image != nil {
//            views["imageView"] = imageView
//        }
//        return views
//    }
//
//    open override func defaultVisualConstraints() -> [String] {
//        if self.imageView!.image != nil {
//            if let text = titleLabel.text , text.count > 0 {
//                return ["H:[imageView]-[titleLabel]-[textField]-16-|"]
//            } else {
//                return ["H:[imageView]-[textField]-16-|"]
//            }
//        } else {
//            if let text = titleLabel.text , text.count > 0 {
//                return ["H:|-16-[titleLabel]-[textField]-16-|"]
//            } else {
//                return ["H:|-16-[textField]-16-|"]
//            }
//        }
//    }
//
//    // MARK: UITextViewDelegate
//
//    open func textViewDidChange(_ textView: UITextView) {
//        guard let text = textView.text , text.count > 0 else { rowDescriptor?.value = nil; update(); return }
//        rowDescriptor?.value = text as AnyObject
//        update()
//    }
//}
