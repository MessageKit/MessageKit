//
//  CameraInput.swift
//  ChatExample
//
//  Created by Mohannad on 12/25/20.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import UIKit
import InputBarAccessoryView

protocol  CameraInputBarAccessoryViewDelegate : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith attachments: [AttachmentManager.Attachment])
}

extension CameraInputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith attachments: [AttachmentManager.Attachment]){
        
    }
}


 class CameraInputBarAccessoryView: InputBarAccessoryView {
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    func configure(){
        let camera = makeButton(named: "ic_camera")
        camera.tintColor = .darkGray
        camera.onTouchUpInside { (item) in
            self.showImagePickerControllerActionSheet()
        }
        self.setLeftStackViewWidthConstant(to: 35, animated: true)
        self.setStackViewItems([camera], forStack: .left, animated: false)
        self.inputPlugins = [attachmentManager]

    }
    
    override func didSelectSendButton() {
        
        if attachmentManager.attachments.count > 0 {
            
            (delegate as? CameraInputBarAccessoryViewDelegate)?.inputBar(self, didPressSendButtonWith: attachmentManager.attachments)
        }
        else {
            
            delegate?.inputBar(self, didPressSendButtonWith: inputTextView.text)
        }
    }
    
    
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                   
                if #available(iOS 13.0, *) {
                    $0.image = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
                } else {
                    $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                }
                
                $0.setSize(CGSize(width: 30, height: 30), animated: false)
            }.onSelected {
                $0.tintColor = .systemBlue
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
    
}




extension CameraInputBarAccessoryView : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @objc  func showImagePickerControllerActionSheet()  {
        

        let photoLibraryAction = UIAlertAction(title: "Choose From Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take From Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default , handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose Your Image", message: nil, actions: [photoLibraryAction, cameraAction , cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType){
        
        let imgPicker = UIImagePickerController()
         imgPicker.delegate = self
         imgPicker.allowsEditing = true
         imgPicker.sourceType = sourceType
         inputAccessoryView?.isHidden = true
         getRootViewController()?.present(imgPicker, animated: true, completion: nil)
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[  UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // self.sendImageMessage(photo: editedImage)
            self.inputPlugins.forEach { _ = $0.handleInput(of: editedImage)}

        }
        else if let originImage = info[  UIImagePickerController.InfoKey.originalImage] as? UIImage {
 
            self.inputPlugins.forEach { _ = $0.handleInput(of: originImage)}
             //self.sendImageMessage(photo: originImage)
        }
        getRootViewController()?.dismiss(animated: true, completion: nil)
        inputAccessoryView?.isHidden = false
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        getRootViewController()?.dismiss(animated: true, completion: nil)
        inputAccessoryView?.isHidden = false
    }
    
    
    func getRootViewController() -> UIViewController? {
       return (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
    }
    
    
}


extension CameraInputBarAccessoryView: AttachmentManagerDelegate {
    
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        self.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        self.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        self.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        self.showImagePickerControllerActionSheet()
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = self.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}



