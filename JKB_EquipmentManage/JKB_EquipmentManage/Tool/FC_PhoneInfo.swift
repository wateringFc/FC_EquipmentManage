//
//  FC_PhoneInfo.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/16.
//  Copyright © 2019年 JKB. All rights reserved.
//

enum ComparisonResult:Int {
    ///升序
    case orderedAscending = -1
    ///相等
    case orderedSame = 0
    ///降序
    case orderedDescending = 1
    ///不可比较
    case orderedError = 2
}

import Foundation

    //版本比较
    func versionCompare(v1:String,v2:String) -> ComparisonResult {
        //判断合法性
        if checkSeparat(vString: v1) == "" || checkSeparat(vString: v2) == ""{
            return .orderedError
        }
        //获得两个数组
        let v1Arr = cutUpNumber(vString: v1) as! [String]
        let v2Arr = cutUpNumber(vString: v2) as! [String]
        //比较版本号
        return compareNumber(v1Arr: v1Arr, v2Arr: v2Arr)
    }
    //提取连接符
    func checkSeparat(vString:String) -> String {
        var separated:String = ""
        if vString.contains("."){  separated = "." }
        if vString.contains("-"){  separated = "-" }
        if vString.contains("/"){  separated = "/" }
        if vString.contains("*"){  separated = "*" }
        if vString.contains("_"){  separated = "_" }
        
        return separated
    }
    //提取版本号
    func cutUpNumber(vString:String) -> NSArray {
        let  separat = checkSeparat(vString: vString)
        let b = NSCharacterSet(charactersIn:separat) as CharacterSet
        let vStringArr = vString.components(separatedBy: b)
        return vStringArr as NSArray
    }

    //比较版本
    func compareNumber(v1Arr:[String],v2Arr:[String]) -> ComparisonResult {
        for i in 0..<v1Arr.count{
            if  Int(v1Arr[i])! != Int(v2Arr[i])! {
                if Int(v1Arr[i])! > Int(v2Arr[i])! {
                    //降序 v1 > v2
                    return .orderedDescending
                }else {
                    //升序 v1 < v2
                    return .orderedAscending
                }
            }
        }
        //相等
        return .orderedSame
    }

    /// 获取手机具体型号
    ///
    /// - Returns: 手机具体型号
    func iphoneType() ->String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        if platform == "iPhone1,1" { return "iPhone 2G"}
        if platform == "iPhone1,2" { return "iPhone 3G"}
        if platform == "iPhone2,1" { return "iPhone 3GS"}
        if platform == "iPhone3,1" { return "iPhone 4"}
        if platform == "iPhone3,2" { return "iPhone 4"}
        if platform == "iPhone3,3" { return "iPhone 4"}
        if platform == "iPhone4,1" { return "iPhone 4S"}
        if platform == "iPhone5,1" { return "iPhone 5"}
        if platform == "iPhone5,2" { return "iPhone 5"}
        if platform == "iPhone5,3" { return "iPhone 5C"}
        if platform == "iPhone5,4" { return "iPhone 5C"}
        if platform == "iPhone6,1" { return "iPhone 5S"}
        if platform == "iPhone6,2" { return "iPhone 5S"}
        if platform == "iPhone7,1" { return "iPhone 6 Plus"}
        if platform == "iPhone7,2" { return "iPhone 6"}
        if platform == "iPhone8,1" { return "iPhone 6S"}
        if platform == "iPhone8,2" { return "iPhone 6S Plus"}
        if platform == "iPhone8,4" { return "iPhone SE"}
        if platform == "iPhone9,1" { return "iPhone 7"}
        if platform == "iPhone9,2" { return "iPhone 7 Plus"}
        if platform == "iPhone10,1" { return "iPhone 8"}
        if platform == "iPhone10,2" { return "iPhone 8 Plus"}
        if platform == "iPhone10,3" { return "iPhone X"}
        if platform == "iPhone10,4" { return "iPhone 8"}
        if platform == "iPhone10,5" { return "iPhone 8 Plus"}
        if platform == "iPhone10,6" { return "iPhone X"}
        if platform == "iPhone11,2" { return "iPhone XS"}
        if platform == "iPhone11,4" { return "iPhone XS Max"}
        if platform == "iPhone11,6" { return "iPhone XS Max"}
        if platform == "iPhone11,8" { return "iPhone XR"}
        if platform == "iPhone11,8" { return "iPhone XR"}
        
        if platform == "iPod1,1" { return "iPod Touch 1G"}
        if platform == "iPod2,1" { return "iPod Touch 2G"}
        if platform == "iPod3,1" { return "iPod Touch 3G"}
        if platform == "iPod4,1" { return "iPod Touch 4G"}
        if platform == "iPod5,1" { return "iPod Touch 5G"}
        
        if platform == "iPad1,1" { return "iPad 1"}
        if platform == "iPad2,1" { return "iPad 2"}
        if platform == "iPad2,2" { return "iPad 2"}
        if platform == "iPad2,3" { return "iPad 2"}
        if platform == "iPad2,4" { return "iPad 2"}
        if platform == "iPad2,5" { return "iPad Mini 1"}
        if platform == "iPad2,6" { return "iPad Mini 1"}
        if platform == "iPad2,7" { return "iPad Mini 1"}
        if platform == "iPad3,1" { return "iPad 3"}
        if platform == "iPad3,2" { return "iPad 3"}
        if platform == "iPad3,3" { return "iPad 3"}
        if platform == "iPad3,4" { return "iPad 4"}
        if platform == "iPad3,5" { return "iPad 4"}
        if platform == "iPad3,6" { return "iPad 4"}
        if platform == "iPad4,1" { return "iPad Air"}
        if platform == "iPad4,2" { return "iPad Air"}
        if platform == "iPad4,3" { return "iPad Air"}
        if platform == "iPad4,4" { return "iPad Mini 2"}
        if platform == "iPad4,5" { return "iPad Mini 2"}
        if platform == "iPad4,6" { return "iPad Mini 2"}
        if platform == "iPad4,7" { return "iPad Mini 3"}
        if platform == "iPad4,8" { return "iPad Mini 3"}
        if platform == "iPad4,9" { return "iPad Mini 3"}
        if platform == "iPad5,1" { return "iPad Mini 4"}
        if platform == "iPad5,2" { return "iPad Mini 4"}
        if platform == "iPad5,3" { return "iPad Air 2"}
        if platform == "iPad5,4" { return "iPad Air 2"}
        if platform == "iPad6,3" { return "iPad Pro 9.7"}
        if platform == "iPad6,4" { return "iPad Pro 9.7"}
        if platform == "iPad6,7" { return "iPad Pro 12.9"}
        if platform == "iPad6,8" { return "iPad Pro 12.9"}
        
        if platform == "i386"   { return "iPhone Simulator"}
        if platform == "x86_64" { return "iPhone Simulator"}
        
        return platform
    }


