//
//  FC_AddNewAssetsViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/12.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import Alamofire
import CDAlertView

class FC_AddNewAssetsViewController: FormViewController {

    /// 所属科室 视图
    var selectView = FC_SelectDepartmentView()
    
    /// 弹出科室选择视图
    fileprivate lazy var viewss:FC_DepartmentView = {
        let viewss = FC_DepartmentView(frame: CGRect(x: 0, y: kScreenH - kSafeBottomAreaH - 200, width: kScreenW, height: 200))
        return viewss
    }()
    
    /// 科室/部门数据源
    fileprivate lazy var deptDatas = NSMutableArray()
    /// 选中部门id
    fileprivate var selectId: Int?
    
    fileprivate lazy var sectionHeadView:UIView = {
        let sectionHeadView = UIView()
        return sectionHeadView
    }()
    
    
    /// 折旧方式
    fileprivate let fc_pickerOptions = ["平均年限法", "工作量法", "双倍余额递减法", "年数总和法"] as [AnyObject]
    fileprivate let fc_typeOptions = ["非易耗品", "易耗品"] as [AnyObject]
    
    struct Static {
        static let name = "name" // 资产名称
        static let coding = "coding" //"型号"
        static let size = "size"//"规格"
        static let location = "location"//"归属位置"
        static let number = "number"//"数量"
        static let unit = "unit"//"单位"
        static let price = "price"//"购买单价"
        static let depreciation = "depreciation"//"折旧方式"
        static let type = "type"//"类型"
        static let supplier = "supplier"//"供货商"
        static let origin = "origin"//"产地"
        static let replenishDate = "replenishDate"//"进货日期"
        static let dateLength = "dateLength"//"预计使用期限"
        static let agent = "agent"//"经办人"
        static let note = "note"//"备注"
        static let button = "button"//"按钮"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllDeptData()
        self.loadForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewss.removeFromSuperview()
    }
    
    /// 获取所有部门数据
    fileprivate func getAllDeptData() {
        
        FC_NetProvider.shared.getAllDept(success: { (allDeptArr) in
            self.deptDatas = NSMutableArray.init(array: allDeptArr)
            // 构建“产库”模型，插入到第一个
            var model = AllDeptModel()
            model.id = 0
            model.name = "仓库"
            self.deptDatas.insert(model, at: 0)
            // 构建“添加+”模型，插入到数组
            var model1 = AllDeptModel()
            model1.id = -1
            model1.name = "添加 +"
            self.deptDatas.add(model1)
            
            // 给弹出视图赋值
            self.viewss.datas = self.deptDatas as! [AllDeptModel]
            
        }, failure: { (_) in
            // 失败
            
        }) { (res) in
            // 如果传过来是空字典，说明第一次请求，默认添加一个【仓库】
            if res.isEmpty {
                var model = AllDeptModel()
                model.id = 0
                model.name = "仓库"
                self.deptDatas.add(model)
                
                var model1 = AllDeptModel()
                model1.id = -1
                model1.name = "添加 +"
                self.deptDatas.add(model1)
            }
        }
    }
    
    // MARK: - tableview头尾
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            sectionHeadView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 10)
            sectionHeadView.backgroundColor = .white
            return sectionHeadView
            
        }else if section == 1 {
            // 创建所属科室视图
            selectView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 30)
            // 点击了选择部门
            selectView.didSelectBlock = {
                
                // 点击【叉叉】-=-=-=-=-
                self.viewss.didDepartmentViewCloseBlock = { idx, titleStr in
                    
                    let alert = CDAlertView.init(title: "删除部门", message: "是否删除\(titleStr)？", type: .warning)
                    let cancel = CDAlertViewAction.init(title: "取消")
                    alert.add(action: cancel)
                    
                    let del = CDAlertViewAction.init(title: "删除", font: nil, textColor: nil, backgroundColor: nil, handler: { (CDAlertViewAction) -> Bool in
                        // 删除
                        let model:AllDeptModel = self.deptDatas[idx] as! AllDeptModel
                        assert(model.id > 0, "部门id不能为空")
                        FC_NetProvider.shared.deleteDept(id: model.id, success: { (res) in
                            FC_HUD.fc_showSuccess("部门删除成功!")
                            // 刷新部门数据
                            self.getAllDeptData()
                        }, failure: { (_) in })
                        
                        return true
                    })
                    alert.add(action: del)
                    alert.show()
                }
                
                
                // 点击【行】-=-=-=-=-
                self.viewss.didSelectRowBlock = { idx, titleStr in
                    self.selectView.valueLabel.text = titleStr
                    self.selectId = idx
                }
                
                // 点击【添加】
                self.viewss.didAddBlock = {
                    
                    let alert = CDAlertView.init(title: nil, message: "请输入部门名称", type: .noImage)
                    alert.isTextFieldHidden = false
                    alert.textFieldPlaceholderText = "仅限10字以内"
                    alert.textFieldTextColor = Main_222222_Color
                    
                    let cancel = CDAlertViewAction.init(title: "取消")
                    alert.add(action: cancel)
                    
                    let add = CDAlertViewAction.init(title: "添加", font: nil, textColor: UIColor.white, backgroundColor: Theme_4B77F6_Blue, handler: { (CDAlertViewAction) -> Bool in
                        if alert.textFieldText?.count ?? 0 < 1 || !alert.textFieldText!.isUserName {
                            FC_HUD.fc_showInfo("请检查部门名称是否正确")
                            return false // false代表点击之后不隐藏，反之隐藏
                        }else {
                            // 添加部门
                            FC_NetProvider.shared.addDept(name: alert.textFieldText!, success: { (res) in
                                FC_HUD.fc_showSuccess("部门添加成功!")
                                // 刷新部门数据
                                self.getAllDeptData()
                            }, failure: { (_) in })
                            return true
                        }
                    })
                    alert.add(action: add)
                    alert.show()
                }
                
                appDelegate.window?.addSubview(self.viewss)
            }
            return selectView
            
        }else if section == 2 {
            let aview = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 15))
            view.backgroundColor = UIColor.white
            let topView = UIView(frame: CGRect(x: 0, y: 5, width: kScreenW, height: 5))
            topView.backgroundColor = Bg_f5f5f5
            aview.addSubview(topView)
            return aview
            
        }else {
            sectionHeadView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 30)
            sectionHeadView.backgroundColor = .white
            return sectionHeadView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10.0
        }else if section == 2 {
            return 15.0
        }else {
            return 30.0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: 私有方法
    fileprivate func loadForm() {
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        
        title = "新增资产"
        let form = FormDescriptor()
        
        // 段头1
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        var row = FormRowDescriptor(tag: Static.name, type: .name, title: "资产名称：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        section1.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.coding, type: .name, title: "型号：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        section1.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.size, type: .name, title: "规格：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section1.rows.append(row)
        
        
//        row = FormRowDescriptor(tag: Static.department, type: .fc_picker, title: "所属科室：")
//        row.configuration.cell.showsInputToolbar = true
//        row.configuration.selection.options = fc_pickerOptions // 数据源赋值
//        row.configuration.selection.optionTitleClosure = { value in
//            guard let option = value as? String else { return "" }
//            return option
//        }
////        row.value = fc_pickerOptions[0] as AnyObject // 默认选中第一个（如不需要显示第一个则注释）
//        row.configuration.cell.appearance = [
//            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
//        section1.rows.append(row)
        
        
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.location, type: .name, title: "归属位置：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section2.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.number, type: .number, title: "数量：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        section2.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.unit, type: .name, title: "单位：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section2.rows.append(row)
        
        // 段头3
        let section3 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.price, type: .decimal, title: "购买单价：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        section3.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.depreciation, type: .fc_picker, title: "折旧方式：")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = fc_pickerOptions // 数据源赋值
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
//        row.value = fc_pickerOptions[0] as AnyObject // 默认选中第一个（如不需要显示第一个则注释）
        row.configuration.cell.appearance = [
            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
        section3.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.type, type: .fc_picker, title: "类型：")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = fc_typeOptions
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        //        row.value = fc_pickerOptions[0] as AnyObject // 默认选中第一个（如不需要显示第一个则注释）
        row.configuration.cell.appearance = [
            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
        section3.rows.append(row)
        
    
        row = FormRowDescriptor(tag: Static.supplier, type: .name, title: "供货商：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section3.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.origin, type: .name, title: "产地：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入" as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section3.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.replenishDate, type: .fc_date, title: "进货日期：")
        row.configuration.cell.showsInputToolbar = true
        section3.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.dateLength, type: .number, title: "预计使用年限：")
        row.configuration.cell.appearance = ["textField.placeholder" : "点击输入,年为单位" as AnyObject]
        row.configuration.cell.isHiddenStars = true
        section3.rows.append(row)
        
        // 段头4
        let section4 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.agent, type: .label, title: "经办人：")
        let arr = FC_SQLiteManager.manager.selectAll()
        if arr.count > 0 {
            let info = arr[0]
            row.value = info.name as AnyObject
        }else {
            row.value = "" as AnyObject
        }
        section4.rows.append(row)
        
        // ⚠️title一定要包含 ：且 携带最大限制数，否则报错
        row = FormRowDescriptor(tag: Static.note, type: .multilineText, title: "其它备注：20")
        let placeholderStr = "输入备注内容..."
        row.configuration.cell.placeholder = placeholderStr
        row.configuration.cell.appearance = ["textField.text": placeholderStr as AnyObject]
        section4.rows.append(row)
        
        // 段头4
        let section5 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.button, type: .button, title: "提交入库")
        
        row.configuration.button.didSelectClosure = { _ in
            self.view.endEditing(true)
            let set = NSMutableSet()
            let dic = NSMutableDictionary()
            for section in self.form.sections {
                for row in section.rows {
                    if row.type != .button {
                        if let value = row.value {
                            DLog("\(row.tag) \(value)")
                            set.add(row.tag)
                            dic.setValue(value, forKey: row.tag)
                        }
                    }
                }
            }
            
            if !set.contains("name") ||
                !set.contains("coding") ||
                self.selectView.valueLabel.text == "请选择" ||
                self.selectView.valueLabel.text!.count < 1 ||
                !set.contains("number") ||
                !set.contains("price") ||
                !set.contains("depreciation") ||
                !set.contains("type") ||
                !set.contains("replenishDate") {
                FC_HUD.fc_showInfo("带星号为必填项")
                
            }else {
                let name:String = dic["name"]! as! String
                let model:String = dic["coding"]! as! String
                let deptId:Int = self.selectId!
                var address:String?
                let quantity:Int = Int(dic["number"]! as! String)!
                let price:Float = Float(dic["price"]! as! String)!
                let str:String = dic["depreciation"]! as! String
                var depreciation:Int = 0
                if str.contains("平均年限法") {
                    depreciation = 1
                }else if str.contains("工作量法") {
                    depreciation = 2
                }else if str.contains("双倍余额递减法") {
                    depreciation = 3
                }else if str.contains("年数总和法") {
                    depreciation = 4
                }
                var supplier:String?
                var country:String?
                let arr = "\(dic["replenishDate"]!)".components(separatedBy: " ")
                let stockDate:String = arr[0]
                var expectedLife:Int?
                var remark:String?
                var unit:String?
                let typeStr:String = dic["type"]! as! String
                let type:Int = typeStr == "非易耗品" ? 1 : 2
                var spec:String?
                
                if (dic.value(forKey: "location") != nil) {
                    address = dic["location"]! as? String
                }else { address = nil }
                
                if (dic.value(forKey: "supplier") != nil) {
                    supplier = dic["supplier"]! as? String
                }else { supplier = nil }
                
                if (dic.value(forKey: "origin") != nil) {
                    country = dic["origin"]! as? String
                }else { country = nil }
                
                if (dic.value(forKey: "dateLength") != nil) {
                    expectedLife = Int(dic["dateLength"]! as! String)!
                }else { expectedLife = nil }
                
                if (dic.value(forKey: "note") != nil) {
                    remark =  dic["note"]! as? String
                }else { remark = nil }
                
                if (dic.value(forKey: "unit") != nil) {
                    unit =  dic["unit"]! as? String
                }else { unit = nil }
                
                if (dic.value(forKey: "size") != nil) {
                    spec = dic["size"]! as? String
                }else { spec = nil }
                
                DLog("名称:\(name), 型号:\(model), 科室id:\(deptId), 存放位置:\(String(describing: address)), 数量:\(quantity), 单价:\(price), 折旧方式:\(depreciation), 供应商:\(String(describing: supplier)), 产地:\(String(describing: country)), 入库日期 :\(stockDate), 使用期限/年:\(String(describing: expectedLife)), 备注:\(String(describing: remark)), 单位:\(String(describing: unit)), 类型:\(type), 规格:\(String(describing: spec)),")

                FC_NetProvider.shared.addAsset(name: name, model: model, deptId: deptId, address: address, quantity: quantity, price: price, depreciation: depreciation, supplier: supplier, country: country, stockDate: stockDate, expectedLife: expectedLife, remark: remark, unit: unit, type: type, spec: spec, success: { (res) in

                    FC_HUD.fc_showSuccess("资产添加成功")
                    FC_DispatchAfter(after: 2.0, handler: {
                        self.navigationController?.popViewController(animated: true)
                    })

                }, failure: { (_) in })
                
            }
        }
        section5.rows.append(row)
        
        form.sections = [section1, section2, section3, section4, section5]
        self.form = form
    }
}
