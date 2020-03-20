//
//  FC_SQLiteManager.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/11.
//  Copyright © 2019年 JKB. All rights reserved.
//

import Foundation
import SQLite

/// 表字段
let id = Expression<Int64>("rowid")
let token = Expression<String>("token")
let name = Expression<String?>("name")
let phone = Expression<String?>("phone")
let company = Expression<String?>("company")
let headerImg = Expression<String?>("headerImg")

class FC_SQLiteManager: NSObject {
    
    /// 数据库管理者（单例）
    static let manager = FC_SQLiteManager()
    // 数据库链接
    private var db: Connection?
    /// 用户信息 表
    private var table: Table?

    /// 连接数据库
    func getDB() -> Connection {
        if db == nil {
            // 沙盒存放路径
            let path = NSHomeDirectory() + "/Documents/userInfo.sqlite3"
            db = try! Connection(path)
            // 连接尝试重试语句的秒数
            db?.busyTimeout = 5.0
            DLog("与数据库建立连接 成功")
        }
        return db!
    }
    
    /// 获取表
    func getTable() -> Table {
        if table == nil {
            table = Table("user_info")
            try! getDB().run(
                table!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                    builder.column(id, primaryKey: true) // 设置为主键
                    builder.column(token)
                    builder.column(name)
                    builder.column(phone)
                    builder.column(company)
                    builder.column(headerImg)
                })
            )
        }
        return table!
    }
    
    // 增加一条数据(一条数据包含模型中所有字段)
    func insert(_ info: FC_UserInfo) {
        
        let insert = getTable().insert(token <- info.token, name <- info.name, phone <- info.phone, company <- info.company, headerImg <- info.headerImg)
        
        if let rowId = try? getDB().run(insert) {
            DLog("插入成功：数据id=\(rowId)")
        } else {
            DLog("插入失败")
        }
    }
    
    /// 查询所有数据
    func selectAll() -> [FC_UserInfo] {
        var infoArr = [FC_UserInfo]()
        for user in try! getDB().prepare(getTable()) {
            let newInfo  = FC_UserInfo(token: user[token], name: user[name] ?? "", phone: user[phone] ?? "", company: user[company] ?? "", headerImg: user[headerImg] ?? "")
            // 添加到数组中
            infoArr.append(newInfo)
        }
        return infoArr
    }

    /// 根据插入数据的id(目前只存一个用户信息，所以id传1即可) 及 关键字 更新本条数据
    func update(id: Int64, keyWord: String, newsInfo: FC_UserInfo) {
        // 更新 哪条数据
        let update = getTable().filter(rowid == id)

        if keyWord == "token" {
            // 修改token
            if let count = try? getDB().run(update.update(token <- newsInfo.token)) {
                DLog("修改的结果为：\(count == 1)")
            } else { DLog("修改失败")}
            
        }else if keyWord == "name" {
            // 修改名字
            if let count = try? getDB().run(update.update(name <- newsInfo.name)) {
                DLog("修改的结果为：\(count == 1)")
            } else { DLog("修改失败")}
            
        }else if keyWord == "phone" {
            // 修改手机
            if let count = try? getDB().run(update.update(phone <- newsInfo.phone)) {
                DLog("修改的结果为：\(count == 1)")
            } else { DLog("修改失败")}
            
        }else if keyWord == "company" {
            // 修改公司
            if let count = try? getDB().run(update.update(company <- newsInfo.company)) {
                DLog("修改的结果为：\(count == 1)")
            } else { DLog("修改失败")}
            
        }else if keyWord == "headerImg" {
            // 修改头像
            if let count = try? getDB().run(update.update(headerImg <- newsInfo.headerImg)) {
                DLog("修改的结果为：\(count == 1)")
            } else { DLog("修改失败")}
            
        }else if keyWord == "n_p_c" {
            // 修改名字、手机、公司
            if let count = try? getDB().run(update.update(name <- newsInfo.name, phone <- newsInfo.phone, company <- newsInfo.company)) {
                DLog("修改的结果为：\(count == 1)")
            } else { DLog("修改失败") }
        }else{
            // 修改所有字段值
            if let count = try? getDB().run(update.update(token <- newsInfo.token, name <- newsInfo.name, phone <- newsInfo.phone, company <- newsInfo.company, headerImg <- newsInfo.headerImg)) {
                DLog("修改的结果为：\(count == 1)")
            } else { DLog("修改失败") }
        }
    }

    /// 根据id 删除
    func delete(id: Int64) {
        filter_delete(filter: rowid < id)
    }
    
    /// 根据条件删除(参数可以不传，如果传则如： rowid == id 或 name == "xiaoMing")
    func filter_delete(filter: Expression<Bool>? = nil) {
        var query = getTable()
        if let f = filter {
            query = query.filter(f)
        }
        if let count = try? getDB().run(query.delete()) {
            DLog("删除的条数为：\(count)")
        } else {
            DLog("删除失败")
        }
    }
    
    /// 清空本地数据库
    func clearTableData() {
        do {
            if try getDB().run(table!.delete()) > 0 {
                DLog("清空成功")
            }else {
                DLog("清空失败")
            }
        } catch  {
            DLog("清空错误：\(error)")
        }
    }
    
}
