//
//  FC_LevelViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/24.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

public enum LeveType {
    case LeveType_highest /// 高危
    case LeveType_high    /// 危险
    case LeveType_general /// 一般
}

class FC_LevelViewController: UITableViewController {

    var type: LeveType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        switch type {
        case .LeveType_highest?:
            
            break
        case .LeveType_high?:
            
            break
        case .LeveType_general?:
            
            break
        default:
            break
        }
    }
}

extension FC_LevelViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "心脏起搏器 (328101007945785)"
        cell.textLabel?.textColor = Normal_000000_Color
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
}
