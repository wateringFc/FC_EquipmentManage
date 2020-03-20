//
//  FC_RepairViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/23.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public enum vcType {
    case vcType_repair /// 维修
    case vcType_maintenance /// 保养
    case vcType_check /// 巡检
}

class FC_RepairViewController: UIViewController {

    /// 周榜按钮
    @IBOutlet weak var topWeeksBut: UIButton!
    /// 只有点击顶部周榜按钮之后，才显示
    @IBOutlet weak var weeksLb: UILabel!
    
    /// 月榜按钮
    @IBOutlet weak var topMonthBut: UIButton!
    /// 只有点击顶部月榜按钮之后，才显示
    @IBOutlet weak var monthBut: UIButton!
    
    /// 第一科室 名称
    @IBOutlet weak var ks_firstLb: UILabel!
    /// 第一科室 副标题
    @IBOutlet weak var ks_firstSubLb: UILabel!
    
    /// 第二科室 名称
    @IBOutlet weak var ks_secondLb: UILabel!
    /// 第二科室 副标题
    @IBOutlet weak var ks_secondSubLb: UILabel!
    
    /// 第三科室 名称
    @IBOutlet weak var ks_thirdLb: UILabel!
    /// 第三科室 副标题
    @IBOutlet weak var ks_thirdSubLb: UILabel!
    
    /// 列表
    @IBOutlet weak var tableview: UITableView!
    
    /// push类型
    var type: vcType?
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        butAction()
    }
}

extension FC_RepairViewController: PickerDelegate {
    
    fileprivate func setupUI() {
        topMonthBut.alpha = 0.5
        monthBut.isHidden = true
        weeksLb.isHidden = false
        
        tableview?.fc_registerCell(cell: FC_RepairCell.self)
        
        var str: String?
        var keyWord: String?
        
        switch type {
        case .vcType_repair?:
            str = "45%维修"
            keyWord = "维修"
            break
        case .vcType_maintenance?:
            str = "20%保养"
            keyWord = "保养"
            break
        case .vcType_check?:
            str = "35%巡检"
            keyWord = "巡检"
            break
        default:
            break
        }
        
        ks_firstSubLb.attributedText = FC_Tool.fc_changeFontColor(totalString: str!, subString: keyWord!, font: UIFont.systemFont(ofSize: 12), textColor: Normal_000000_Color)
        ks_secondSubLb.attributedText = FC_Tool.fc_changeFontColor(totalString: str!, subString: keyWord!, font: UIFont.systemFont(ofSize: 12), textColor: Normal_000000_Color)
        ks_thirdSubLb.attributedText = FC_Tool.fc_changeFontColor(totalString: str!, subString: keyWord!, font: UIFont.systemFont(ofSize: 12), textColor: Normal_000000_Color)
    }
    
    fileprivate func butAction() {
        // 周榜按钮
        topWeeksBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            self?.topMonthBut.alpha = 0.5
            self?.topWeeksBut.alpha = 1
            self?.monthBut.isHidden = true
            self?.weeksLb.isHidden = false
        }).disposed(by: disposeBag)
        
        // 月榜按钮
        topMonthBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            self?.topWeeksBut.alpha = 0.5
            self?.topMonthBut.alpha = 1
            self?.monthBut.isHidden = false
            self?.weeksLb.isHidden = true
            
            let str = Date().getCurrentDate()
            let arr = str.components(separatedBy: "-")
            let dateStr = "\(arr[0])年\(arr[1])月"
            self?.monthBut.setTitle(dateStr, for: .normal)
            
        }).disposed(by: disposeBag)
        
        // 月份选择按钮
        monthBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            let pickerView = FC_PickerView.init(type: .year_month)
            pickerView.pickerDelegate = self
            pickerView.pickerViewShow()
        }).disposed(by: disposeBag)
    }
    
    // 日期选择器代理方法
    func selectedDate(pickerView: FC_PickerView, dateStr: String) {
        let arr = dateStr.components(separatedBy: "-")
        monthBut.setTitle("\(arr[0])年\(arr[1])月", for: .normal)
    }
}

extension FC_RepairViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview!.fc_dequeueReusableCell(indexPath: indexPath)  as FC_RepairCell
        cell.numLb.text = "\(indexPath.row + 4)"
        cell.selectionStyle = .none
        return cell
    }
}
