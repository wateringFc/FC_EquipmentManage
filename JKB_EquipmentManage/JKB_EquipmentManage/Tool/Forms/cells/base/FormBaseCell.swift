//
//  FormBaseCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormBaseCell: UITableViewCell {
    
    // MARK: Properties
    /// 当前行的value
    open var rowDescriptor: FormRowDescriptor? {
        didSet {
            self.update()
        }
    }
    
    open weak var formViewController: FormViewController?
    
    fileprivate var customConstraints: [NSLayoutConstraint] = []
    
    // MARK: Init
    public required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public interface
    /// 基本配置
    open func configure() {
        /// override
    }
    
    
    /// 更新数据
    open func update() {
        /// override
    }
    
    
    /// 设置约束
    open func defaultVisualConstraints() -> [String] {
        return []
    }
    
    open func constraintsViews() -> [String : UIView] {
        /// override
        return [:]
    }
    
    
    /// 设置第一响应者
    open func firstResponderElement() -> UIResponder? {
        /// override
        return nil
    }
    
    /// 设置弹出视图上方的 辅助视图 （添加一个完成按钮，方便隐藏弹出视图）
    open func inputAccesoryView() -> UIToolbar {
        // 1、添加ToolBar
        let actionBar = UIToolbar()
        actionBar.isTranslucent = true
        actionBar.sizeToFit()
        actionBar.barStyle = .default // 颜色
        // 2、自定义item按钮
        let doneButton = UIButton(type: .custom)
        doneButton.sizeToFit()
        doneButton.setTitle("完成", for: .normal)
        doneButton.setTitleColor(Normal_000000_Color, for: .normal)
        doneButton.addTarget(self, action: #selector(FormBaseCell.handleDoneAction(_:)), for: .touchUpInside)
        let doneItem = UIBarButtonItem.init(customView: doneButton)
        // 3、添加一个空的item，目的是让完成的item靠右显示
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        actionBar.items = [flexible, doneItem]
        return actionBar
    }
    
    /// 收起键盘
    @objc internal func handleDoneAction(_: UIBarButtonItem) {
        firstResponderElement()?.resignFirstResponder()
    }
    
    open class func formRowCellHeight() -> CGFloat {
        return 44.0
    }
    
    open class func formRowCanBecomeFirstResponder() -> Bool {
        return false
    }
    
    /// 表单控制器
    open class func formViewController(_ formViewController: FormViewController, didSelectRow: FormBaseCell) {
    }
    
    // MARK: 更新约束
    open override func updateConstraints() {
        if customConstraints.count > 0 {
            contentView.removeConstraints(customConstraints)
        }
        
        let views = constraintsViews()
        
        customConstraints.removeAll()
        
        var visualConstraints = [String]()
        
        if let visualConstraintsClosure = rowDescriptor?.configuration.cell.visualConstraintsClosure {
            visualConstraints = visualConstraintsClosure(self)
        } else {
            visualConstraints = defaultVisualConstraints()
        }
        
        for visualConstraint in visualConstraints {
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: visualConstraint, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
            for constraint in constraints {
                customConstraints.append(constraint)
            }
        }
        
        contentView.addConstraints(customConstraints)
        super.updateConstraints()
    }
}
