//
//  FC_EquipmentProblemViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/22.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_EquipmentProblemViewController: UIViewController {

    /// 是否是设备故障VC
    var isProblemVc: Bool?
    
    fileprivate lazy var dateBut: UIButton = {
        let str = Date().getCurrentDate()
        let arr = str.components(separatedBy: "-")
        let dateStr = "\(arr[0])-\(arr[1]) >"
        let dateBut = FC_CreateView.createButton(rect: CGRect(x: 20, y: 20 + kNavBarHeight, width: 100, height: 27), title: dateStr, textColor: Normal_000000_Color, font: UIFont.systemFont(ofSize: 13), action: #selector(clickDateBut), sender: FC_EquipmentProblemViewController())
        dateBut.layer.masksToBounds = true
        dateBut.layer.cornerRadius = 14
        dateBut.layer.borderWidth = 1
        dateBut.layer.borderColor = Line_e0e0e0_Gray.cgColor
        return dateBut
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}

extension FC_EquipmentProblemViewController {
    
    fileprivate func setupUI() {
        
        view.backgroundColor = UIColor.white
        view.addSubview(dateBut)
        addHistogramView()
        
    }
    
    fileprivate func addTopView() {
        
    }
    
    fileprivate func addHistogramView() {
        let xValuesArr:[String]?
        if isProblemVc! {
           xValuesArr = ["呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)", "呼吸机(euhgfy-0056566)"]
        }else {
            xValuesArr = ["title_0", "title_1", "title_2", "title_3", "title_4", "title_5", "title_6", "title_7", "title_8", "title_9"]
        }
        
        let yValuesArr = ["85", "209", "185", "395", "500", "260", "136", "150", "78", "310"]
        let histogramView = FCHistogramView(frame: CGRect(x: 0, y: kNavBarHeight + 135, width: view.width, height: kScreenH - 135 - kNavBarHeight - kSafeBottomAreaH), xValues: xValuesArr!, yValues: yValuesArr, barW: 20, gapW: 20, yScaleV: 100, yAxisNum: 6, unitStr: "次", barBgCorlor: HexColor(0x8DC6FA))
        histogramView.barTextColor = Normal_000000_Color
        histogramView.dottedLineColor = HexColor(0xE8E8E8)
        if isProblemVc! { histogramView.isXAxisLabsRotating = true }
        view.addSubview(histogramView)
    }
    
}


// MARK: - 事件响应
extension FC_EquipmentProblemViewController: PickerDelegate {
    
    // 点击日期按钮
    @objc func clickDateBut() {
        let pickerView = FC_PickerView.init(type: .year_month)
        pickerView.pickerDelegate = self
        pickerView.pickerViewShow()
    }
    
    // 日期选择器代理方法
    func selectedDate(pickerView: FC_PickerView, dateStr: String) {
        dateBut.setTitle("\(dateStr) >", for: .normal)
    }
}
