//
//  FC_QRCodeConfig.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/28.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

/// 扫描器类型
enum ScannerType {
    case qr  // 仅支持二维码
    case bar // 仅支持条码
    case both// 支持二维码以及条码
}

/// 扫描区域
enum ScannerArea {
    case def // 扫描框内
    case fullscreen // 全屏
}

struct QRCodeCompat {
    /// 扫描器类型 默认支持二维码以及条码
//    var scannerType: ScannerType = .both
    /// 后期修改 只支持二维码
    var scannerType: ScannerType = .qr
    /// 扫描区域
    var scannerArea: ScannerArea = .def
    /// 棱角颜色 默认RGB色值 r:63 g:187 b:54 a:1.0
    var scannerCornerColor: UIColor = UIColor(red: 63/255.0, green: 187/255.0, blue: 54/255.0, alpha: 1.0)
    /// 边框颜色 默认白色
    var scannerBorderColor: UIColor = .white
    /// 指示器风格
    var indicatorViewStyle: UIActivityIndicatorViewStyle = .whiteLarge
}

