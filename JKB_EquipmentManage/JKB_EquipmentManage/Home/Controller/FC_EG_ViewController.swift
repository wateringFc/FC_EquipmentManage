//
//  FC_EG_ViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/19.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_EG_ViewController: FormViewController {

    let pickerOptions = ["One", "Two", "Three"] as [AnyObject]
    let fc_pickerOptions = ["111111", "2222222", "3333333"] as [AnyObject]
    
    struct Static {
        static let labelTag = "label"
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let fc_picker = "fc_picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadForm()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(FC_EG_ViewController.submit(_:)))
    }
    
    
    // MARK: Actions
    /// 确定
    @objc func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alertController = UIAlertController(title: "Form output", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: 私有方法
    fileprivate func loadForm() {
        
        tableView.backgroundColor = UIColor.red
        
        // nav标题
        let form = FormDescriptor(title: "Nav标题")
        
        
        
        // 段头1
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        var row = FormRowDescriptor(tag: Static.emailTag, type: .email, title: "邮箱:")
        row.configuration.cell.appearance = ["textField.placeholder" : "john@gmail.com" as AnyObject,
                                             "textField.textAlignment" : NSTextAlignment.left.rawValue as AnyObject]
        
        section1.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.passwordTag, type: .password, title: "密码:")
        row.configuration.cell.appearance = ["textField.placeholder" : "Enter password" as AnyObject, "textField.textAlignment" : NSTextAlignment.left.rawValue as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section1.rows.append(row)
        
        
        
        // 段头2
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.nameTag, type: .name, title: "第一个名字")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. Miguel Ángel" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(row)
        row = FormRowDescriptor(tag: Static.lastNameTag, type: .name, title: "第二个名字")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. Ortuño" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section2.rows.append(row)
        row = FormRowDescriptor(tag: Static.jobTag, type: .text, title: "年纪")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. Entrepreneur" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(row)
        
        
        
        // 段头3
        let section3 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.URLTag, type: .url, title: "网址")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. gethooksapp.com" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section3.rows.append(row)
        row = FormRowDescriptor(tag: Static.phoneTag, type: .phone, title: "手机")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. 0034666777999" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section3.rows.append(row)
        
        
        // 段头4
        let section4 = FormSectionDescriptor(headerTitle: "An example header title", footerTitle: "段头4")
        row = FormRowDescriptor(tag: Static.enabled, type: .booleanSwitch, title: "开关")
        section4.rows.append(row)
        row = FormRowDescriptor(tag: Static.check, type: .booleanCheck, title: "对勾")
        section4.rows.append(row)
        row = FormRowDescriptor(tag: Static.segmented, type: .segmentedControl, title: "分段控制")
        row.configuration.selection.options = ([0, 1, 2, 3] as [Int]) as [AnyObject]
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? Int else { return "" }
            switch option {
            case 0:
                return "None"
            case 1:
                return "!"
            case 2:
                return "!!"
            case 3:
                return "!!!"
            default:
                return ""
            }
        }
        row.configuration.cell.appearance = ["titleLabel.font" : UIFont.boldSystemFont(ofSize: 30.0), "segmentedControl.tintColor" : UIColor.red]
        section4.rows.append(row)
        
        
        // 段头5
        let section5 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.picker, type: .picker, title: "性别选择")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = (["F", "M", "U"] as [String]) as [AnyObject]
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            switch option {
            case "F":
                return "Female"
            case "M":
                return "Male"
            case "U":
                return "I'd rather not to say"
            default:
                return ""
            }
        }
        row.value = "M" as AnyObject
        section5.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.birthday, type: .date, title: "生日选择")
        row.configuration.cell.showsInputToolbar = true
        section5.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.categories, type: .multipleSelector, title: "类别push选择")
        row.configuration.selection.options = ([0, 1, 2, 3, 4] as [Int]) as [AnyObject]
        row.configuration.selection.allowsMultipleSelection = true
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? Int else { return "" }
            switch option {
            case 0:
                return "Restaurant"
            case 1:
                return "Pub"
            case 2:
                return "Shop"
            case 3:
                return "Hotel"
            case 4:
                return "Camping"
            default:
                return ""
            }
        }
        
        section5.rows.append(row)
        
        
        // 段头6
        let section6 = FormSectionDescriptor(headerTitle: "段头6", footerTitle: "段尾6")
        
        row = FormRowDescriptor(tag: Static.stepper, type: .stepper, title: "Step count")
        row.configuration.stepper.maximumValue = 200.0
        row.configuration.stepper.minimumValue = 20.0
        row.configuration.stepper.steps = 2.0
        section6.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.slider, type: .slider, title: "Slider")
        row.configuration.stepper.maximumValue = 200.0
        row.configuration.stepper.minimumValue = 20.0
        row.configuration.stepper.steps = 2.0
        row.value = 0.5 as AnyObject
        row.configuration.cell.appearance = ["titleLabel.textColor": UIColor.black,
                                             "sliderView.tintColor": UIColor.red]
        section6.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.picker, type: .picker, title: "弹出选择")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = pickerOptions
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        row.value = pickerOptions[0] as AnyObject
        row.configuration.cell.appearance = [
            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
        section6.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.fc_picker, type: .fc_picker, title: "方存add弹出")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.cell.isHiddenStars = false
        row.configuration.selection.options = fc_pickerOptions // 数据源赋值
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        //        row.value = fc_pickerOptions[0] as AnyObject // 默认选中第一个（如不需要显示第一个则注释）
        row.configuration.cell.appearance = [
            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
        section6.rows.append(row)
        
        
        
        // 段头7
        let section7 = FormSectionDescriptor(headerTitle: "段头7", footerTitle: nil)
        // ⚠️：title未包含：一定要包含,且后面携带最大限制数，否则报错
        row = FormRowDescriptor(tag: Static.textView, type: .multilineText, title: "其它备注：30")
        row.configuration.cell.placeholder = "备注..."
        row.configuration.cell.appearance = ["textField.text": "备注..." as AnyObject]
        section7.rows.append(row)
        
        
        // 段头8
        let section8 = FormSectionDescriptor(headerTitle: "段头8", footerTitle: nil)
        
        row = FormRowDescriptor(tag: Static.labelTag, type: .label, title: "文字显示")
        row.configuration.cell.placeholder = "value，文字"
        section8.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.button, type: .button, title: "取消")
        row.configuration.button.didSelectClosure = { _ in
            self.view.endEditing(true)
        }
        section8.rows.append(row)
        
        form.sections = [section1, section2, section3, section4, section5, section6, section7, section8]
        self.form = form
    }
}
