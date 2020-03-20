//
//  FC_NewFriendCell.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/16.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FC_NewFriendCell: UITableViewCell, RegisterCellFromNib {
    /// 头像
    @IBOutlet weak var headerImag: UIImageView!
    /// 名字
    @IBOutlet weak var nameLb: UILabel!
    /// 企业
    @IBOutlet weak var companyLb: UILabel!
    /// 已添加
    @IBOutlet weak var hasAddLb: UILabel!
    /// 查看按钮
    @IBOutlet weak var checkBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    var didCheckBut: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    private func setupUI() {
        
        hasAddLb.isHidden = true
        checkBut.fc_corner(byRoundingCorners: .allCorners, radii: 2)
        checkBut.layer.borderWidth = 1.0
        checkBut.layer.borderColor = HexColor(0xd9d9d9).cgColor
        
        headerImag.fc_corner(byRoundingCorners: .allCorners, radii: 3)
        
        checkBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { () in
            self.didCheckBut?()
            
        }).disposed(by: disposeBag)
    }
    
}
