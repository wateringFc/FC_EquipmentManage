//
//  FormFCDateCell.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/19.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

open class FormFCDateCell: FormValueCell {

    // cell的高度，需要与【formRowCellHeight()】中的数值保持一致
    fileprivate let textFieldCellH: CGFloat = 30.0
    
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
    
    fileprivate lazy var img: UIImageView = {
        let img = UIImageView(frame: CGRect(x: UIScreen.main.bounds.size.width - 15 - 77, y: (textFieldCellH - 15)/2, width: 15, height: 15))
        img.image = UIImage(named: "home_down")
        return img
    }()
    
    // MARK: Properties
    private let datePicker = UIDatePicker()
    private let hiddenTextField = UITextField(frame: CGRect.zero)
    
    private let defaultDateFormatter = DateFormatter()
    
    // MARK: FormBaseCell
    
    open override class func formRowCellHeight() -> CGFloat {
        return 30.0
    }
    
    open override func configure() {
        super.configure()
        
        accessoryType = .none
        
        contentView.addSubview(starsLb)
        contentView.addSubview(borderView)
        contentView.addSubview(img)
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        
        titleLabel.textColor = Normal_000000_Color
        valueLabel.textColor = Sub_666666_Color
        valueLabel.textAlignment = .left
        
        contentView.addSubview(hiddenTextField)
        
        hiddenTextField.isAccessibilityElement = false
        hiddenTextField.inputView = datePicker // 设置textfield响应弹起为 选择框【关键】
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(FormFCDateCell.valueChanged(_:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        
        if let showsInputToolbar = rowDescriptor?.configuration.cell.showsInputToolbar , showsInputToolbar && hiddenTextField.inputAccessoryView == nil {
            hiddenTextField.inputAccessoryView = inputAccesoryView() // 设置弹出视图上方的自定义工具条
        }
        
        // 左侧标题赋值
        titleLabel.text = rowDescriptor?.title
        valueLabel.text = "请选择"
        starsLb.isHidden = rowDescriptor?.configuration.cell.isHiddenStars ?? false
        
        if let rowType = rowDescriptor?.type {
            switch rowType {
            case .date, .fc_date:
                datePicker.datePickerMode = .date
                defaultDateFormatter.dateStyle = .long
                defaultDateFormatter.timeStyle = .none
            case .time:
                datePicker.datePickerMode = .time
                defaultDateFormatter.dateStyle = .none
                defaultDateFormatter.timeStyle = .short
            default:
                datePicker.datePickerMode = .dateAndTime
                defaultDateFormatter.dateStyle = .long
                defaultDateFormatter.timeStyle = .short
            }
        }
        
        if let date = rowDescriptor?.value as? Date {
            datePicker.date = date
            // 右侧赋值
            valueLabel.text = getDateFormatter().string(from: date)
        }
    }
    
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormFCDateCell else { return }
        
        if row.rowDescriptor?.value == nil {
            let date = Date()
            row.rowDescriptor?.value = date as AnyObject
            row.valueLabel.text = row.getDateFormatter().string(from: date)
            row.update()
        }
        
        row.hiddenTextField.becomeFirstResponder()
    }
    
    open override func defaultVisualConstraints() -> [String] {
        return ["H:|-35-[titleLabel]", "H:|-152-[valueLabel]-77-|"]
    }
    
    open override func firstResponderElement() -> UIResponder? {
        return hiddenTextField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    @objc internal func valueChanged(_ sender: UIDatePicker) {
        rowDescriptor?.value = sender.date as AnyObject
        valueLabel.text = getDateFormatter().string(from: sender.date)
        update()
    }
    
    // MARK: Private interface
    
    fileprivate func getDateFormatter() -> DateFormatter {
        guard let dateFormatter = rowDescriptor?.configuration.date.dateFormatter else { return defaultDateFormatter }
        return dateFormatter
    }
}
