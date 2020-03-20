//
//  FC_NetworkPath.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/5.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

#if DEBUG
/// 开发请求地址
let RequestPath = "http://192.168.45.202:8152/operation"
/// 测试文件访问地址
let FilePath = "http://192.168.45.200/fileserver/"

#else
/// 正式请求地址
let RequestPath = ""
/// 正式文件访问地址
let FilePath = ""
#endif


//MARK: ***************接口*******************
/// 版本升级接口
let updateInfoURL = "/horn/appUpdateInfo"
/// 图文教程地址
let graphicCourseLink = "http://lifecircle-horn-test.51youdian.com:9060/page/flowChart.html"
/// 失败原因接口
let reasonFailureLink = "http://lifecircle-horn-test.51youdian.com:9060/page/index.html"
