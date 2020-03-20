//
//  AppDelegate.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/5.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initializeWindow()
        keyboardManager()
        
        return true
    }
    
    
    /// 设置window
    private func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FC_TabBarViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
    
    /// 全局设置键盘管理工具
    private func keyboardManager() {
        let keyboardManager: IQKeyboardManager = IQKeyboardManager.sharedManager()
        // 启用/禁用管理键盘和textField之间的距离。默认值是YES(在' +(void)load '方法中加载类时启用)。
        keyboardManager.enable = true
        // 设置键盘与文本框的距离。不可能小于零。默认是10.0。
        keyboardManager.keyboardDistanceFromTextField = 10
        // 点击输入框之外的区域是否收起键盘。默认是false
        keyboardManager.shouldResignOnTouchOutside = true
//        // 隐藏键盘上的工具条
//        keyboardManager.enableAutoToolbar = false
//        // 是否显示占位文字
//        keyboardManager.shouldShowToolbarPlaceholder = false
        // 设置工具条上的文字为完成
        keyboardManager.toolbarDoneBarButtonItemText = "完成"
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

