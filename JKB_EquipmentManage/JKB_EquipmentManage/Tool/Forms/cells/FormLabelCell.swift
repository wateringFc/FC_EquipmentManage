//
//  FormTextFieldCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 20/08/14.
//  Copyright (c) 2016 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormLabelCell: FormValueCell {
    
    /// MARK: FormBaseCell
    
    override open func configure() {
        super.configure()
        
        accessoryType = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = Normal_000000_Color
        valueLabel.textColor = Sub_666666_Color
        
        valueLabel.textAlignment = .left
        
//        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
//        valueLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        // apply constant constraints
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
    open override class func formRowCellHeight() -> CGFloat {
        return 30.0
    }
    
    // fc新增，重写父类方法
    open override func defaultVisualConstraints() -> [String] {
        return ["H:|-35-[titleLabel]", "H:|-132-[valueLabel]-15-|"]
    }

    override open func update() {
        super.update()
        
        titleLabel.text = rowDescriptor?.title
        valueLabel.text = rowDescriptor?.value as? String
    }
}
