//
//  FC_NetAPIManager.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import Foundation
import Moya

enum FC_NetAPIManager {
    // MARK: - 登录注册、通用接口-------------------------------------------------
    case fc_login(userName: String, userPaswd: String) // 登录
    case fc_reg(username: String, password: String, ensurePassword: String, phone: String, company: String) // 注册
    case fc_sendMsg(phone: String, type:Int) // 发送短信
    case fc_msgVerify(phone: String, msgCode: String, type: Int) // 验证短信
    case fc_logOut() // 退出登录
    case fc_userInfo() // 获取用户信息
    
    case fc_allDept() // 获取所有部门
    case fc_addDept(name: String) // 添加部门
    case fc_deleteDept(id: Int) // 删除部门
    
    // MARK: - 资产管理-------------------------------------------------
    case zc_assetDetail(code: String) // 资产详情
    case zc_addAsset(name: String, model: String, deptId: Int, address: String?, quantity: Int, price: Float, depreciation: Int, supplier: String?, country: String?, stockDate: String?, expectedLife: Int?, remark: String?, unit: String?, type: Int, spec: String?) // 添加资产
}

extension FC_NetAPIManager: TargetType {
    
    // MARK: - 主路径 -------------------------------------------------
    var baseURL: URL {
        return URL(string: RequestPath)!
    }
    
    // MARK: - 请求接口 -------------------------------------------------
    var path: String {
        switch self {
        // =======登录注册======
        case .fc_login(_, _):
            return "/user/login"
        case .fc_sendMsg(_, _):
            return "/msg/send"
        case .fc_reg(_,_,_,_,_):
            return "/register"
        case .fc_msgVerify(_,_,_):
            return "/msg/verify"
        case .fc_logOut():
            return "/user/logout"
        case .fc_userInfo():
            return "/user/info"
        case .fc_allDept():
            return "/dept/all"
        case .fc_addDept(_):
            return "/dept/add"
        case .fc_deleteDept(_):
            return "/dept/delete"
        
        // =======资产管理======
        case .zc_assetDetail(_):
            return "/property/detail"
        case .zc_addAsset:
            return "/property/add"
        }
    }
    
    // MARK: - 请求方法 -------------------------------------------------
    var method: Moya.Method {
        switch self {
            // POST请求
        case .fc_login(_, _),
             .fc_sendMsg(_, _),
             .fc_reg(_,_,_,_,_),
             .fc_msgVerify(_,_,_),
             .fc_addDept(_),
             .zc_addAsset:
            return .post
            
        case .fc_deleteDept(_):
            return .delete
            
        default:
            // GET请求
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // MARK: - 请求参数 -------------------------------------------------
    var parameters: [String: Any] {
        var paramsDict: [String : Any] = [:]
        paramsDict["appId"] = "app"
        
        switch self {
        // ========登录注册=======
        case .fc_login(let userName, let userPaswd):
            paramsDict["username"] = userName
            paramsDict["password"] = userPaswd
         
        case .fc_sendMsg(let phone, let type):
            paramsDict["phone"] = phone
            paramsDict["type"] = type
            
        case .fc_reg(let username, let password, let ensurePassword, let phone, let company):
            paramsDict["username"] = username
            paramsDict["password"] = password
            paramsDict["ensurePassword"] = ensurePassword
            paramsDict["phone"] = phone
            paramsDict["company"] = company
            
        case .fc_msgVerify(let phone, let msgCode, let type):
            paramsDict["phone"] = phone
            paramsDict["msgCode"] = msgCode
            paramsDict["type"] = type
      
        case .fc_addDept(let name):
            paramsDict["name"] = name
            
        case .fc_deleteDept(let id):
            paramsDict["deptId"] = id
            
            
        // =========资产管理======
        case .zc_assetDetail(let codeOrId):
            paramsDict["codeOrId"] = codeOrId
        case .zc_addAsset(let name, let model, let deptId, let address, let quantity, let price, let depreciation, let supplier, let country, let stockDate, let expectedLife, let remark, let unit, let type, let spec):
            paramsDict["name"] = name
            paramsDict["model"] = model
            paramsDict["deptId"] = deptId
            if address != nil { paramsDict["address"] = address }
            paramsDict["quantity"] = quantity
            paramsDict["price"] = price
            paramsDict["depreciation"] = depreciation
            if supplier != nil{ paramsDict["supplier"] = supplier }
            if country != nil{ paramsDict["country"] = country }
            if stockDate != nil{ paramsDict["stockDate"] = stockDate }
            if expectedLife != nil{ paramsDict["expectedLife"] = expectedLife }
            if remark != nil{ paramsDict["remark"] = remark }
            if unit != nil { paramsDict["unit"] = unit }
            paramsDict["type"] = type
            if spec != nil { paramsDict["spec"] = spec }
            
        default:
            // 无参数(含默认参数)
            return paramsDict
        }
        return paramsDict
    }
    
    
    var task: Task {
        switch self {
        // ========登录注册=======
        case .fc_login(_,_),
             .fc_sendMsg(_, _),
             .fc_reg(_,_,_,_,_),
             .fc_msgVerify(_,_,_),
             .fc_userInfo(),
             .fc_logOut(),
             .fc_allDept(),
             .fc_addDept(_),
             .fc_deleteDept(_):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        // =========资产管理======
        case .zc_assetDetail(_),
             .zc_addAsset:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
//        default:
//            // 没有参数的请求
//            return .requestPlain
        }
    }

    
    // MARK: - 请求头 -------------------------------------------------
    var headers: [String : String]? {
        switch self {
        case .fc_login(_,_),
             .fc_sendMsg(_,_),
             .fc_reg(_,_,_,_,_),
             .fc_msgVerify(_,_,_):
            return ["fm":"app"]
            
        default:
            // 查询本地数据库中token值
            let infoArr:[FC_UserInfo] = FC_SQLiteManager.manager.selectAll()
            if infoArr.count > 0 {
                let info:FC_UserInfo = infoArr[0]
                if info.token.hasPrefix("Optional(") {
                    let arr = info.token.components(separatedBy: "(")
                    let str = arr[1]
                    let arr1 = str.components(separatedBy: ")")
                    let tokenStr = arr1[0] as String
                    DLog("请求头token 带op == \(tokenStr)")
                    return ["Authorization":tokenStr, "fm":"app"]
                }else {
                    DLog("请求头token == \(info.token)")
                    return ["Authorization":info.token, "fm":"app"]
                }
                
            }else {
               return ["fm":"app"]
            }
        }
    }
}
