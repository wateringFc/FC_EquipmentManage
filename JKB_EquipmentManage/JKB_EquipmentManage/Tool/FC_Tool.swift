//
//  FC_Tool.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/22.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_Tool: NSObject {

    
    /// 富文本,修改关键字
    ///
    /// - Parameters:
    ///   - totalString: 总字符串
    ///   - subString: 需要改变的字符串
    ///   - font: 字体大小
    ///   - textColor: 字体颜色
    class func fc_changeFontColor(totalString: String, subString: String, font: UIFont, textColor: UIColor)-> NSMutableAttributedString {
        let attStr = NSMutableAttributedString.init(string: totalString)
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font], range: NSRange.init(location: totalString.count-subString.count, length: subString.count))
        return attStr
    }
}
