//
//  FormTextFieldCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit
// fc 输入框
open class FormTextFieldCell: FormBaseCell {
    
    // MARK: Cell views
    // cell的高度，需要与【formRowCellHeight()】中的数值保持一致
    fileprivate let textFieldCellH: CGFloat = 30.0
    
    public  let titleLabel = UILabel()
    @objc public  let textField  = UITextField()
    
    // MARK: Properties
    fileprivate var customConstraints: [AnyObject] = []
    
    
    fileprivate lazy var starsLb: UILabel = {
        let starsLb = UILabel(frame: CGRect(x: 24, y: 0, width: 8, height: textFieldCellH))
        starsLb.text = "*"
        starsLb.textColor = .red
        return starsLb
    }()
    
    fileprivate lazy var borderView: UIView = {
        let borderView = UIView(frame: CGRect(x: 132, y: 3, width: UIScreen.main.bounds.size.width - (132 + 67), height: textFieldCellH - 3*2))
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        return borderView
    }()
    
    open override class func formRowCellHeight() -> CGFloat {
        return 30.0
    }
    
    // MARK: FormBaseCell
    open override func configure() {
        super.configure()
        
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // 源码
//        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
//        textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)

        titleLabel.font = UIFont.systemFont(ofSize: 12)
        textField.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = Normal_000000_Color
        textField.textColor = Sub_666666_Color
        
        textField.textAlignment = .left
        contentView.addSubview(starsLb)
        contentView.addSubview(borderView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
//        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0)) // 源码
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0.0, constant: contentView.frame.size.height - 12)) // 修改
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        textField.addTarget(self, action: #selector(FormTextFieldCell.editingChanged(_:)), for: .editingChanged)
    }
    
    open override func update() {
        super.update()
        
        if let showsInputToolbar = rowDescriptor?.configuration.cell.showsInputToolbar , showsInputToolbar && textField.inputAccessoryView == nil {
            textField.inputAccessoryView = inputAccesoryView()
        }
        
        titleLabel.text = rowDescriptor?.title
        textField.text = rowDescriptor?.value as? String
        textField.placeholder = rowDescriptor?.configuration.cell.placeholder
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        
        // 是否隐藏
        starsLb.isHidden = rowDescriptor?.configuration.cell.isHiddenStars ?? false
        
        if let type = rowDescriptor?.type {
            switch type {
            case .text:
                textField.autocorrectionType = .default // 文本自校正类型
                textField.autocapitalizationType = .sentences
                textField.keyboardType = .default
            case .number:
                textField.keyboardType = .numberPad
            case .numbersAndPunctuation:
                textField.keyboardType = .numbersAndPunctuation
            case .decimal:
                textField.keyboardType = .decimalPad
            case .name:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .words
                textField.keyboardType = .default
            case .phone:
                textField.keyboardType = .phonePad
            case .namePhone:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .words
                textField.keyboardType = .namePhonePad
            case .url:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .URL
            case .twitter:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .twitter
            case .email:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .emailAddress
            case .asciiCapable:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .asciiCapable
            case .password:
                textField.isSecureTextEntry = true
                textField.clearsOnBeginEditing = false
            default:
                break
        }
        }
    }
    
    open override func constraintsViews() -> [String : UIView] {
        var views = ["titleLabel" : titleLabel, "textField" : textField]
        if self.imageView!.image != nil {
            views["imageView"] = imageView
        }
        return views
    }
    
    open override func defaultVisualConstraints() -> [String] {
        if self.imageView!.image != nil {
            if titleLabel.text != nil && (titleLabel.text!).count > 0 {
                return ["H:[imageView]-[titleLabel]-[textField]-16-|"]
            } else {
                return ["H:[imageView]-[textField]-16-|"]
            }
        } else {
            if titleLabel.text != nil && (titleLabel.text!).count > 0 {
//                return ["H:|-16-[titleLabel]-[textField]-16-|"] // 源码
                return ["H:|-35-[titleLabel]", "H:|-152-[textField]-77-|"] // 修改
                
            } else {
                return ["H:|-16-[textField]-16-|"]
            }
        }
    }
    
    open override func firstResponderElement() -> UIResponder? {
        return textField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    
    @objc func editingChanged(_ sender: UITextField) {
        guard let text = sender.text, text.count > 0 else { rowDescriptor?.value = nil; update(); return }
        rowDescriptor?.value = text as AnyObject
    }
}
