//
//  FormFCPickerCell.swift
//  SwiftForms
//
//  Created by 方存 on 2019/6/18.
//  Copyright © 2019年 Miguel Angel Ortuno Ortuno. All rights reserved.
//

import UIKit

open class FormFCPickerCell: FormValueCell , UIPickerViewDelegate, UIPickerViewDataSource {
    
    // cell的高度，需要与【formRowCellHeight()】中的数值保持一致
    fileprivate let textFieldCellH: CGFloat = 30.0
    
    // MARK: Properties
    private let picker = UIPickerView()
    // 隐藏的textfield，用于响应弹出视图
    private let hiddenTextField1 = UITextField(frame: CGRect.zero)
    
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
    
    // MARK: FormBaseCell
    open override func configure() {
        super.configure()
        
        contentView.addSubview(starsLb)
        contentView.addSubview(borderView)
        contentView.addSubview(img)
        starsLb.isHidden = rowDescriptor?.configuration.cell.isHiddenStars ?? false
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        
        titleLabel.textColor = Normal_000000_Color
        valueLabel.textColor = Sub_666666_Color
        valueLabel.textAlignment = .left
        
        accessoryType = .none
        
        picker.delegate = self
        picker.dataSource = self
        hiddenTextField1.inputView = picker // 弹出的视图
        hiddenTextField1.isAccessibilityElement = false
        
        contentView.addSubview(hiddenTextField1)
    }
    
    
    open override class func formRowCellHeight() -> CGFloat {
        return 30.0
    }
    
    // 重写父类更新 方法
    open override func update() {
        super.update()
        
        // 选择器读取数据
        picker.reloadAllComponents()
        
        // 设置弹出视图上方的辅助视图
        if let showsInputToolbar = rowDescriptor?.configuration.cell.showsInputToolbar , showsInputToolbar && hiddenTextField1.inputAccessoryView == nil {
            hiddenTextField1.inputAccessoryView = inputAccesoryView()
        }
        
        // 控件赋值
        titleLabel.text = rowDescriptor?.title
        valueLabel.text = "请选择"
        
        // 如果父类已存储值
        if let selectedValue = rowDescriptor?.value {
            // 赋值给控件
            valueLabel.text = rowDescriptor?.configuration.selection.optionTitleClosure?(selectedValue)
            // 如果外部传入数据源不为空
            if let options = rowDescriptor?.configuration.selection.options , !options.isEmpty {
                var selectedIndex: Int?
                // 遍历数据源，得到 值 与 下标
                for (index, value) in options.enumerated() {
                    if value === selectedValue {
                        selectedIndex = index
                        break
                    }
                }
                
                if let index = selectedIndex {
                    // 设置picker打开的时候选中的是上一次选择的下标
                    picker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
    }
    
    // fc新增，重写父类方法
    open override func defaultVisualConstraints() -> [String] {
        return ["H:|-35-[titleLabel]", "H:|-152-[valueLabel]-77-|"]
    }
    
    /// 第一响应者
    open override func firstResponderElement() -> UIResponder? {
        return hiddenTextField1
    }
    
    /// 重写父类方法
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        
        // 获取到当前cell
        guard let row = selectedRow as? FormFCPickerCell else { return }
        
        // 如果当前的 value 为空
        if selectedRow.rowDescriptor?.value == nil {
            // 获取到外部赋值的数据源
            guard let options = selectedRow.rowDescriptor?.configuration.selection.options , !options.isEmpty else { return }
            // 默认选中第一个
            let value = options[0]
            selectedRow.rowDescriptor?.value = value
            row.valueLabel.text = selectedRow.rowDescriptor?.configuration.selection.optionTitleClosure?(value)
            // 弹出视图
            row.hiddenTextField1.becomeFirstResponder()
            
        } else {
            // 获取到已有的 value
            guard let value = selectedRow.rowDescriptor?.value else { return }
            // 赋值给 valueLabel
            row.valueLabel.text = selectedRow.rowDescriptor?.configuration.selection.optionTitleClosure?(value)
            // 弹出视图
            row.hiddenTextField1.becomeFirstResponder()
        }
    }
    
    // MARK: UIPickerViewDelegate
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let options = rowDescriptor?.configuration.selection.options , !options.isEmpty else { return nil }
        guard row < options.count else { return nil }
        return rowDescriptor?.configuration.selection.optionTitleClosure?(options[row])
    }
    
    // 滑动选择器之后
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 拿到外部传入数据源
        guard let options = rowDescriptor?.configuration.selection.options , !options.isEmpty else { return }
        guard row < options.count else { return }
        // 根据下标从数据源拿到值
        let newValue = options[row]
        // 赋值给父类cell的参数，父类参数已添加监听值变化，一但变化并调用 更新 方法
        rowDescriptor?.value = newValue
        // 赋值给控件
        valueLabel.text = rowDescriptor?.configuration.selection.optionTitleClosure?(newValue)
    }
    
    // MARK: UIPickerViewDataSource
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 拿到外部传入数据源
        guard let options = rowDescriptor?.configuration.selection.options else { return 0 }
        return options.count
    }
}
