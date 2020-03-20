//
//  FC_NetProvider.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import Moya
import Result
import SwiftyJSON

/// 错误码
enum ProviderError: LocalizedError {
    case server
    case data
    case message(msg: String)
    
    var description: String {
        switch self {
        case .server:
            return "连接到服务器失败"
        case .data:
            return "获取数据失败"
        case .message(let msg):
            return msg
        }
    }
}

/******************************************************/
// 网络日志输出
let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: { (data: Data) -> Data in
    //            return Data()
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)// Data 转 JSON
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)// JSON 转 Data，格式化输出。
        return prettyData
    } catch {
        return data
    }
})

// 设置请求头（废弃）
let myEndpointClosure = { (target: FC_NetAPIManager) -> Endpoint<FC_NetAPIManager> in
    
    let url = target.baseURL as URL
    let urlStr = url.appendingPathComponent(target.path).absoluteString
    
    let endpoint: Endpoint<FC_NetAPIManager> = Endpoint<FC_NetAPIManager>(
        url: urlStr,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    return endpoint.adding(newHTTPHeaderFields: ["Authorization" : "Bearer aabbcc"])
}
/******************************************************/

/// 管理网络状态的插件
let networkPlugin = NetworkActivityPlugin { (change, _) in
    switch(change){
    case .ended:
        // 结束
        FC_HUD.fc_dismiss()
    case .began:
        // 开始
        FC_HUD.fc_withStatus("加载中...")
    }
}

/// 设置请求超时时间，默认30s
let requestTimeoutClosure = { (endpoint: Endpoint<FC_NetAPIManager>, done: @escaping MoyaProvider<FC_NetAPIManager>.RequestResultClosure) in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 30
        done(.success(urlRequest))
    }else{
        done(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

/// 模拟网络请求
let myStubClosure: (FC_NetAPIManager) -> Moya.StubBehavior = { type in
    switch type {
    default:
        return Moya.StubBehavior.delayed(seconds: 1)
    }
}

class FC_NetProvider {
    fileprivate let failureStr = "连接到服务器失败"
    
    /// 单例
    static let shared = FC_NetProvider()
    
    /// 添加自定义插件
    let fc_provider = MoyaProvider<FC_NetAPIManager>(
        requestClosure: requestTimeoutClosure,
        plugins: [networkLoggerPlugin, networkPlugin])

    /// 检查是否要更新token（只有需要token的接口才添加该方法检测）
    func chackToken(_ moyaResponse: Response) {
        let dic = moyaResponse.response?.allHeaderFields
        let token = "\(String(describing: dic?["Authorization"]))"
        var newToken = ""
        if token.count > 30 {
            if token.hasPrefix("Optional(") {
                let arr = token.components(separatedBy: "(")
                let str = arr[1]
                let arr1 = str.components(separatedBy: ")")
                newToken = arr1[0] as String
                DLog("新token 带op：\(newToken)")
            }else {
                newToken = token
            }
        }else {
            DLog("本次请求没有token")
        }
        
        // 查询本地数据库中token值与新值比对，只有有新的token值，才更新本地数据库中的token值
        let infoArr:[FC_UserInfo] = FC_SQLiteManager.manager.selectAll()
        if infoArr.count > 0 {
            let info:FC_UserInfo = infoArr[0]
            if info.token.hasPrefix("Optional(") {
                let arr = info.token.components(separatedBy: "(")
                let str = arr[1]
                let arr1 = str.components(separatedBy: ")")
                let tokenStr = arr1[0] as String
                updateToken(tokenStr: tokenStr, newToken: newToken)
            }else {
                let tokenStr = info.token
                updateToken(tokenStr: tokenStr, newToken: newToken)
            }
        }else { DLog("本地数据库中无数据") }
    }
    
    func updateToken(tokenStr: String, newToken: String) {
        if tokenStr != newToken {
            var info = FC_UserInfo()
            info.token = newToken
            FC_SQLiteManager.manager.update(id: 1, keyWord: "token", newsInfo: info)
            DLog("============= token已更换 ==============")
        }else {
            DLog("不用更换")
        }
    }
    
    /// 请求成功之后的操作(常规请求可以使用，减少代码量)
    func successAfterAction(_ moyaResponse: Response, success:@escaping (Dictionary<String, Any>)->()) {
        do {
            let any = try moyaResponse.mapJSON()
            guard let value = any as? [String:AnyObject] else {return}
            let res: Int = value["result"] as! Int
            if res == 1 {
                // 回调成功后的结果
                success(value)
            }else {
                let isMsg = value.keys.contains("message")
                // 如果token失效、为空、信息不存在、登录失效 则清空本地数据库
                let code = value["code"] as! Int
                if code == 209 || code == 212 || code == 210 || code == 206 || code == 201{
                    FC_SQLiteManager.manager.delete(id: 100)
                }
                if isMsg == true {
                    FC_HUD.fc_showInfo(value["message"] as! String)
                    return
                }
            }
        } catch {}
    }
}

// MARK: - 登录注册 ---------------------------
extension FC_NetProvider {
    /// 登录
    func login(userName: String, paswd: String,
               success:@escaping (Dictionary<String, Any>)->(),
               failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.fc_login(userName: userName, userPaswd: paswd)) { result in
            
            switch result {
            case let .success(moyaResponse):
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 发送短信
    func sendMsg(phone: String, type: Int,
                 success:@escaping (Dictionary<String, Any>)->(),
                 failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.fc_sendMsg(phone: phone, type: type)) { result in
            switch result {
            case let .success(moyaResponse):
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 验证短信
    func msgVerify(phone:String, msgCode:String, type:Int,
                   success:@escaping (Dictionary<String, Any>)->(),
                   failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.fc_msgVerify(phone: phone, msgCode: msgCode, type: type)) { result in
            switch result {
            case let .success(moyaResponse):
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 注册
    func reg(username:String, password:String, ensurePassword:String, phone:String, company:String,
             success:@escaping (Dictionary<String, Any>)->(),
             failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.fc_reg(username: username, password: password, ensurePassword: ensurePassword, phone: phone, company: company)) { result in
            switch result {
            case let .success(moyaResponse):
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 退出登录
    func logOut(success:@escaping (Dictionary<String, Any>)->(),
                failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.fc_logOut()) { result in
            switch result {
            case let .success(moyaResponse):
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 获取用户信息
    func userInfo(success:@escaping (Dictionary<String, Any>)->(),
                  failure:@escaping (ProviderError)->()) {
        fc_provider.request(.fc_userInfo()) { result in
            switch result {
            case let .success(moyaResponse):
                self.chackToken(moyaResponse)
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 获取所有部门
    func getAllDept(success:@escaping (_ allDept: [AllDeptModel])->(),
                    failure:@escaping (ProviderError)->(),
                    noData:@escaping (Dictionary<String, Any>)->()) {
        
        fc_provider.request(.fc_allDept()) { result in
            switch result {
            case let .success(moyaResponse):
                self.chackToken(moyaResponse)
                do {
                    let any = try moyaResponse.mapJSON()
                    guard let value = any as? [String:AnyObject] else {return}
                    let res: Int = value["result"] as! Int
                    
                    if res == 1 {
                        let json = JSON(value)
                        // 如果是数组.则数据转模型.回调
                        if let data = json["data"].arrayObject {
                            success(data.compactMap({ AllDeptModel.deserialize(from: $0 as? Dictionary) }))
                        }
                        
                    }else {
                        let isMsg = value.keys.contains("message")
                        
                        // 如果token失效、为空、信息不存在、登录失效 则清空本地数据库
                        let code = value["code"] as! Int
                        if code == 209 || code == 212 || code == 210 || code == 206 || code == 201{
                            FC_SQLiteManager.manager.delete(id: 100)
                        }
                        
                        if isMsg == true {
                            // 这里比较特殊，因为后台没有返回默认仓库字段，需要自己添加，所以没有数据的时候不提示
                            if value["message"] as! String != "没有数据" {
                                FC_HUD.fc_showInfo(value["message"] as! String)
                            }
                            // 回调空字典，没有数据
                            let emptyDictionary = Dictionary<String,Any>()
                            noData(emptyDictionary)
                            return
                        }
                    }
                } catch {}
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 添加部门
    func addDept(name: String, success:@escaping (Dictionary<String, Any>)->(),
                    failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.fc_addDept(name: name)) { result in
            switch result {
            case let .success(moyaResponse):
                self.chackToken(moyaResponse)
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 删除部门
    func deleteDept(id: Int, success:@escaping (Dictionary<String, Any>)->(),
                 failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.fc_deleteDept(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                self.chackToken(moyaResponse)
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
}

// MARK: - 资产管理 ---------------------------
extension FC_NetProvider {
    
    /// 资产详情
    func assetDetail(codeOrId:String , success:@escaping (Dictionary<String, Any>)->(),
                  failure:@escaping (ProviderError)->()) {
        fc_provider.request(.zc_assetDetail(code: codeOrId)) { result in
            switch result {
            case let .success(moyaResponse):
                self.chackToken(moyaResponse)
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
    /// 添加资产
    func addAsset(name: String, model: String, deptId: Int, address: String?, quantity: Int, price: Float, depreciation: Int, supplier: String?, country: String?, stockDate: String, expectedLife: Int?, remark: String?, unit: String?, type: Int, spec: String?, success:@escaping (Dictionary<String, Any>)->(), failure:@escaping (ProviderError)->()) {
        
        fc_provider.request(.zc_addAsset(name: name, model: model, deptId: deptId, address: address, quantity: quantity, price: price, depreciation: depreciation, supplier: supplier, country: country, stockDate: stockDate, expectedLife: expectedLife, remark: remark, unit: unit, type: type, spec: spec)) { result in
            switch result {
            case let .success(moyaResponse):
                self.chackToken(moyaResponse)
                self.successAfterAction(moyaResponse, success: success)
                
            case let .failure(error):
                DLog(error)
                FC_HUD.fc_showError(self.failureStr)
            }
        }
    }
    
}
