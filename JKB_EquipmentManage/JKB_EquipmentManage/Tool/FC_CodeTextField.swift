//
//  FC_CodeTextField.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/10.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

protocol FC_CodeTextFieldDelegate {
    func didClickBackWard()
}

class FC_CodeTextField: UITextField {

    var fc_delegate: FC_CodeTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = Theme_4B77F6_Blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        fc_delegate?.didClickBackWard()
    }
}
