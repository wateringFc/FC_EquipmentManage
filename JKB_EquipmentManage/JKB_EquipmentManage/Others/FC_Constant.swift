//
//  FC_Constant.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/5.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 短信发送类型
enum MsgType: Int{
    //   免密登录             实名认证        用户注册         修改密码           修改手机
    case Msg_AvoidLogin = 0, Msg_RealName, Msg_Registered, Msg_ChangePaswd, Msg_ChangePhone
}

/// 延迟执行
func FC_DispatchAfter(after: Double, handler:@escaping ()->()){
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        handler()
    }
}

/// 封装的日志输出功能（T表示不指定日志信息参数类型）
func DLog<T>(_ message:T, file:String = #file, function:String = #function,
              line:Int = #line) {
    #if DEBUG
    //获取文件名
    let fileName = (file as NSString).lastPathComponent
    //打印日志内容
    print("\(fileName): line:\(line) \(function) | \(message)")
    #endif
}

/// 屏幕宽
let kScreenW : CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高
let kScreenH : CGFloat = UIScreen.main.bounds.size.height
/// 屏宽比
let kUISreenW_Scale = kScreenW / 375
/// 屏高比
let kUISreenH_Scale = kScreenH / 667

/// 状态栏默认高度
let kStatusBarHeight : CGFloat = (iPhoneX() ? 44.0 : 20.0)
/// 导航栏默认高度
let kNavBarHeight : CGFloat = (iPhoneX() ? 88.0 : 64.0)
/// 底部默认安全高度
let kSafeBottomAreaH : CGFloat = (iPhoneX() ? 34.0 : 0.0)
/// Tabbar默认高度
let kTabBarHeight : CGFloat = (iPhoneX() ? 83.0 : 49.0)
/// 配置表单cell高度
let kFormCellHeight : CGFloat =  30.0



/// X XR XS XS_MAX
func iPhoneX() -> Bool { return UIScreen.main.bounds.size.height >= 812.0 }
/// 4  4s
func iPhone4() ->Bool { return UIScreen.main.bounds.size.height == 480.0 }
/// 5  5s
func iPhone5() ->Bool { return UIScreen.main.bounds.size.height == 568.0 }
/// 6  6s  7
func iPhone6() ->Bool { return UIScreen.main.bounds.size.height == 667.0 }
/// 6plus  6splus  7plus
func iPhone6plus() ->Bool { return UIScreen.main.bounds.size.height == 736.0 }

/// 主题蓝
let Theme_4B77F6_Blue:UIColor = HexColor(0x4B77F6)
/// 主题灰蓝
let Grey_95B3F9_Blue:UIColor = HexColor(0x95B3F9)
/// 背景色
let Bg_f5f5f5:UIColor = HexColor(0xf5f5f5)
/// 分割线
let Line_e0e0e0_Gray:UIColor = HexColor(0xe0e0e0)
/// 默认字体颜色
let Normal_000000_Color:UIColor = HexColor(0x000000)
/// 主字体颜色
let Main_222222_Color:UIColor = HexColor(0x222222)
/// 副标题颜色
let Sub_666666_Color:UIColor = HexColor(0x666666)
/// 占位字体颜色
let Content_999999_Color:UIColor = HexColor(0x999999)

/// 十六进制色值
let HexColor:((Int) -> UIColor) = { (rgbValue : Int) -> UIColor in
    return HexRGBAlpha(rgbValue, 1.0)
}

let HexRGBAlpha:((Int,Float) -> UIColor) = { (rgbValue : Int, alpha : Float) -> UIColor in
    return UIColor(red: CGFloat(CGFloat((rgbValue & 0xFF0000) >> 16)/255), green: CGFloat(CGFloat((rgbValue & 0xFF00) >> 8)/255), blue: CGFloat(CGFloat(rgbValue & 0xFF)/255), alpha: CGFloat(alpha))
}

let RGBAlpa:((Float,Float,Float,Float) -> UIColor ) = { (r: Float, g: Float , b: Float , a: Float ) -> UIColor in
    return UIColor.init(red: CGFloat(CGFloat(r)/255.0), green: CGFloat(CGFloat(g)/255.0), blue: CGFloat(CGFloat(b)/255.0), alpha: CGFloat(a))
}

/// 设置字体 样式 及 大小
let TextStyleFont:((String ,Float ) -> UIFont) = {
    (fontName:String ,fontSize:Float ) -> UIFont in
    if #available(iOS 9.0, macOS 10,*) {
        return UIFont.init(name: fontName, size: CGFloat(fontSize))!
    }else {
        return UIFont.systemFont(ofSize: CGFloat(fontSize))
    }
}

/// 获取Appdelegate
let appDelegate = UIApplication.shared.delegate as! AppDelegate
/// 获取命名空间
let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String

// MARK : 系统相关
let kiOSBase = 8.0
let kOSGreaterOrEqualToiOS8 = ( (Double(UIDevice.current.systemVersion) ?? kiOSBase) > 8.0 ) ? true : false;
let kOSGreaterOrEqualToiOS9 = ((Double(UIDevice.current.systemVersion) ?? kiOSBase) >= 9.0 ) ? true : false;
let kOSGreaterOrEqualToiOS10 = ((Double(UIDevice.current.systemVersion) ?? kiOSBase) >= 10.0 ) ? true : false;
let kOSGreaterOrEqualToiOS11 = ((Double(UIDevice.current.systemVersion) ?? kiOSBase) >= 11.0 ) ? true : false;

/// app版本  以及设备系统版本
let kAppBundleInfoVersion = Bundle.main.infoDictionary ?? Dictionary()
/// App版本号
let kAppBundleVersion = (kAppBundleInfoVersion["CFBundleShortVersionString" as String] as? String ) ?? ""
///  Appbuild版本号
let kAppBundleBuild = (kAppBundleInfoVersion["CFBundleVersion"] as? String ) ?? ""
/// App名称
let kAppDisplayName = (kAppBundleInfoVersion["CFBundleDisplayName"] as? String ) ?? ""

// MARK : 过滤空值
///过滤null的字符串，当nil时返回一个初始化的空字符串
let kNullString:((Any)->String) = {(obj: Any) -> String in
    if obj is String {
        return obj as! String
    }
    return ""
}

/// 过滤null的数组，当nil时返回一个初始化的空数组
let kNullArray:((Any)->Array<Any>) = {(obj: Any) -> Array<Any> in
    if obj is Array<Any> {
        return obj as! Array<Any>
    }
    return Array()
}

/// 过滤null的字典，当为nil时返回一个初始化的字典
let kNullDic:((Any) -> Dictionary<AnyHashable, Any>) = {( obj: Any) -> Dictionary<AnyHashable, Any> in
    if obj is Dictionary<AnyHashable, Any> {
        return obj as! Dictionary<AnyHashable, Any>
    }
    return Dictionary()
}

/// 根据imageName创建一个UIImage
let imageNamed:((String) -> UIImage? ) = { (imageName : String) -> UIImage? in
    return UIImage.init(named: imageName)
}

/// 根据Main.storyboard建立ViewController
let VC_From_Main_SB:((String)-> UIViewController? ) = {(SBID : String) -> UIViewController? in
    return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:SBID)
    }


let FC_UserDefault = UserDefaults.standard
/// Cache缓存文件夹
let cacheDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
/// Documents文件夹
let documentsDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first

/// 读取本地图片 （文件名，后缀名）
func loadImage(imageName __imgName__:String,imgExtension __imgExt__:String) -> UIImage {
    return UIImage.init(contentsOfFile: Bundle.main.path(forResource: __imgName__, ofType: __imgExt__)!)!
}
/// 定义UIImage对象 （文件名）  png格式
func loadPNGImage(imageName __imgName__:String) -> UIImage {
    return UIImage.init(contentsOfFile: Bundle.main.path(forResource: __imgName__, ofType: "png")!)!
}


/// 计算文本的高度
///
/// - Parameters:
///   - text: 文本
///   - textSize: 文字大小
///   - availableW: 有效宽度
/// - Returns: 最终高度
func fc_calculateTextHeight(text : String, textSize: CGFloat, availableW: CGFloat) -> CGFloat {
    let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: textSize)]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect:CGRect = text.boundingRect(with: CGSize(width: availableW, height: 0), options: option, attributes: attributes, context: nil)
    return rect.size.height
}

///// 角度转弧度
///// - Parameter __ANGLE__: 角度
///// - Returns: 弧度值
//func FC_Angle_To_Radian(__ANGLE__:CGFloat) ->CGFloat {
//    return (CGFloat(M_PI) * __ANGLE__ / 180.0)
//}
//
///// 弧度转角度
///// - Parameter __RADIAN__: 弧度
///// - Returns: 角度
//func FC_Radian_To_Angle(__RADIAN__:CGFloat) ->CGFloat {
//    return (CGFloat(__RADIAN__ * 180 / CGFloat(M_PI)))
//}

