//
//  FC_UserInfo.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/11.
//  Copyright © 2019年 JKB. All rights reserved.
//

import Foundation
import HandyJSON

struct FC_UserInfo: HandyJSON {
    /// 登录令牌
    var token: String = ""
    /// 姓名
    var name: String = ""
    /// 手机
    var phone: String = ""
    /// 公司
    var company: String = ""
    /// 头像
    var headerImg: String = ""
}
