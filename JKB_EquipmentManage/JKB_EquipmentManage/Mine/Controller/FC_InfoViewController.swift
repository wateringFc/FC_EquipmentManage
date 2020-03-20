//
//  FC_InfoViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/27.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos

class FC_InfoViewController: UIViewController {

    
    /// 头像
    @IBOutlet weak var headImg: UIImageView!
    /// 名字
    @IBOutlet weak var nameLb: UILabel!
    /// 公司
    @IBOutlet weak var companyLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headImg.fc_corner(byRoundingCorners: .allCorners, radii: 5)
    }
    
    
    @IBAction func buts(_ sender: UIButton) {
        if sender.tag == 10 {
            let vc = FC_SetupNameViewController()
            vc.blockNameStr = {(nameStr: String) -> Void in
                self.nameLb.text = nameStr
            }
            vc.nameStr = nameLb.text
            vc.title = "设置名字"
            navigationController?.pushViewController(vc, animated: true)
            
        }else {
            
        }
    }
    
    /// 检查是否打开相机权限
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus != .restricted && authStatus != .denied { }else {
            let alert = UIAlertController(title: "警告", message: "请前往：设置->\(kAppDisplayName)->打开相机权限", preferredStyle: .alert)
            let shooting = UIAlertAction(title: "好的", style: .default) { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(shooting)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /// 检查是否打开照片权限
    func checkPhotoLibrary() {
        let authStatus = ALAssetsLibrary.authorizationStatus()
        if authStatus != .restricted && authStatus != .denied {  }else {
            let alert = UIAlertController(title: "警告", message: "请前往：设置->\(kAppDisplayName)->打开照片读写权限", preferredStyle: .alert)
            let shooting = UIAlertAction(title: "好的", style: .default) { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(shooting)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /// 选择头像
    @IBAction func selectorImg(_ sender: UIButton) {
        let alert = UIAlertController(title: "选择头像来源", message: nil, preferredStyle: .actionSheet)
        let shooting = UIAlertAction(title: "立即拍摄", style: .default) { (UIAlertAction) in
            
            self.checkCamera()
            
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                FC_HUD.fc_showInfo("设备不支持相机")
                return
            }
            
            let pickerPhoto = UIImagePickerController()
            pickerPhoto.delegate = self
            pickerPhoto.allowsEditing = true//设置可编辑
            pickerPhoto.sourceType = .camera
            self.present(pickerPhoto, animated: true, completion: nil)//进入照相界面
        }
        
        let photo = UIAlertAction(title: "从相册中选择", style: .default) { (UIAlertAction) in
            
            self.checkPhotoLibrary()
            
            let pickerCamera = UIImagePickerController()
            pickerCamera.allowsEditing = true
            pickerCamera.sourceType =  .photoLibrary
            pickerCamera.delegate = self
            
            self.present(pickerCamera, animated: true, completion: nil)
        }
            
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in }
        alert.addAction(shooting)
        alert.addAction(photo)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension FC_InfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePickerc = info[UIImagePickerControllerOriginalImage] as! UIImage
        headImg.image = imagePickerc
        self.dismiss(animated: true, completion: nil)
    }
}
