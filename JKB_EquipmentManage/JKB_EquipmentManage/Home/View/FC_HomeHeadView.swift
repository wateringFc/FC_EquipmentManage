//
//  FC_HomeHeadView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/8.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class FC_HomeHeadView: UIView {

    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    fileprivate let imgs: [String] = ["home_icn_fuc_list", "home_icn_fuc_mantn", "home_icn_fuc_opro", "home_icn_fuc_ins",
                                      "home_icn_fuc_check", "home_icn_fuc_measure", "home_icn_fuc_atn", "home_icn_fuc_benif",
                                      "home_icn_fuc_bro", "home_icn_fuc_cut", "home_icn_fuc_change", "home_icn_fuc_charg"]
    fileprivate let texts: [String] = ["设备清单", "维修管理", "一级养护", "日常巡检", "性能检测", "计量管理", "保修提醒", "效益分析", "借调中心", "资产盘点", "资产转科", "资产报废"]
    
    /// 定义一个闭包
    typealias indexPathItem = (Int, String) -> ()
    /// 实例化闭包对象，用与回调item索引值
    var clickItem: indexPathItem?
    
    /// 主入口
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(topStatuView)
        addSubview(collectionView)
        addSubview(bottomView)
        
        // rx调用代理方法，闭包回传索引值
        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.clickItem?(indexPath.item, self.texts[indexPath.item])
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topStatuView.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(43)
        }
        
        collectionView.snp.makeConstraints { (make) in
            let w = (kScreenW - 20*2 - 3)/4
            make.top.equalTo(topStatuView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(w*3+4)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(70)
        }
    }
    
    
    /// 顶部状态栏
    private lazy var topStatuView:UIView = {
        let topStatuView = UIView()
        topStatuView.backgroundColor = HexColor(0xf2f2f2)
        
        let img = UIImageView(frame: CGRect(x: 20, y: 14, width: 16, height: 16))
        img.image = UIImage(named: "home_icn_remind")
        topStatuView.addSubview(img)
        
        let label = UILabel(frame: CGRect(x: 46, y: 0, width: kScreenW - 46 - 20, height: 43))
        label.text = "皮肤科电脑设备已经超过3小时未修复，无法打印处方信息"
        label.font = TextStyleFont("PingFang SC", 12)
        label.textColor = Normal_000000_Color
        topStatuView.addSubview(label)
        return topStatuView
    }()

    /// layout
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        let w = (kScreenW - 20*2 - 3)/4
        layout.itemSize = CGSize(width: w, height: w)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(1, 20, 1, 20)
        return layout
    }()
    
    /// 网格列表
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FC_HeadViewCell.self, forCellWithReuseIdentifier: "FC_HeadViewCell")
        return collectionView
    }()
    
    
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        let line = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 10))
        line.backgroundColor = HexColor(0xf2f2f2)
        bottomView.addSubview(line)
        
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: 200, height: 60))
        label.text = "维修知识"
        label.textColor = Normal_000000_Color
        label.font = UIFont.boldSystemFont(ofSize: 15)
        bottomView.addSubview(label)
        return bottomView
    }()
}

// MARK: - collectionView代理方法
extension FC_HomeHeadView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: FC_HeadViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FC_HeadViewCell", for: indexPath) as! FC_HeadViewCell
        cell.iconImg.image = UIImage(named: imgs[indexPath.item])
        cell.textLb.text = texts[indexPath.item]
        return cell
    }
}


// MARK: - 网格cell类
class FC_HeadViewCell: UICollectionViewCell {
    
    fileprivate lazy var iconImg: UIImageView = UIImageView()
    fileprivate lazy var textLb: UILabel = {
        let textLb = UILabel()
        textLb.textColor = Normal_000000_Color
        textLb.font = TextStyleFont("PingFang SC", 12)
        textLb.textAlignment = .center
        return textLb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconImg)
        addSubview(textLb)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLb.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.left.right.equalToSuperview()
        }
        
        iconImg.snp.makeConstraints { (make) in
            make.bottom.equalTo(textLb.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
