//
//  CameraInput.swift
//  ChatExample
//
//  Created by Mohannad on 12/25/20.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import InputBarAccessoryView
import UIKit

// MARK: - CameraInputBarAccessoryViewDelegate

protocol CameraInputBarAccessoryViewDelegate: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith attachments: [AttachmentManager.Attachment])
}

extension CameraInputBarAccessoryViewDelegate {
  func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: [AttachmentManager.Attachment]) { }
}

// MARK: - CameraInputBarAccessoryView

class CameraInputBarAccessoryView: InputBarAccessoryView {
  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  lazy var attachmentManager: AttachmentManager = { [unowned self] in
    let manager = AttachmentManager()
    manager.delegate = self
    return manager
  }()

  override func didSelectSendButton() {
    if attachmentManager.attachments.count > 0 {
      (delegate as? CameraInputBarAccessoryViewDelegate)?
        .inputBar(self, didPressSendButtonWith: attachmentManager.attachments)
    }
    else {
      delegate?.inputBar(self, didPressSendButtonWith: inputTextView.text)
    }
  }

  func configure() {
    let camera = makeCameraButton()
    camera.tintColor = .darkGray
    camera.onTouchUpInside { [weak self] _ in
      self?.showImagePickerControllerActionSheet()
    }
    setLeftStackViewWidthConstant(to: 35, animated: true)
    setStackViewItems([camera], forStack: .left, animated: false)
    inputPlugins = [attachmentManager]
  }

  // MARK: Private

  private func makeCameraButton() -> InputBarButtonItem {
    InputBarButtonItem()
      .configure {
        $0.spacing = .fixed(10)
        $0.image = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
        $0.setSize(CGSize(width: 30, height: 30), animated: false)
      }.onSelected {
        $0.tintColor = .systemBlue
      }.onDeselected {
        $0.tintColor = UIColor.lightGray
      }
  }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension CameraInputBarAccessoryView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc
  func showImagePickerControllerActionSheet() {
    let photoLibraryAction = UIAlertAction(title: "Choose From Library", style: .default) { [weak self] _ in
      self?.showImagePickerController(sourceType: .photoLibrary)
    }

    let cameraAction = UIAlertAction(title: "Take From Camera", style: .default) { [weak self] _ in
      self?.showImagePickerController(sourceType: .camera)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

    AlertService.showAlert(
      style: .actionSheet,
      title: "Choose Your Image",
      message: nil,
      actions: [photoLibraryAction, cameraAction, cancelAction],
      completion: nil)
  }

  func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
    let imgPicker = UIImagePickerController()
    imgPicker.delegate = self
    imgPicker.allowsEditing = true
    imgPicker.sourceType = sourceType
    imgPicker.presentationController?.delegate = self
    inputAccessoryView?.isHidden = true
    getRootViewController()?.present(imgPicker, animated: true, completion: nil)
  }

  func imagePickerController(
    _: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
  {
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      inputPlugins.forEach { _ = $0.handleInput(of: editedImage) }
    }
    else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      inputPlugins.forEach { _ = $0.handleInput(of: originImage) }
    }
    getRootViewController()?.dismiss(animated: true, completion: nil)
    inputAccessoryView?.isHidden = false
  }

  func imagePickerControllerDidCancel(_: UIImagePickerController) {
    getRootViewController()?.dismiss(animated: true, completion: nil)
    inputAccessoryView?.isHidden = false
  }

  func getRootViewController() -> UIViewController? {
    UIViewController.keyWindowRoot
  }
}

// MARK: @preconcurrency AttachmentManagerDelegate

extension CameraInputBarAccessoryView: @preconcurrency AttachmentManagerDelegate {
  // MARK: - AttachmentManagerDelegate

  func attachmentManager(_: AttachmentManager, shouldBecomeVisible: Bool) {
    setAttachmentManager(active: shouldBecomeVisible)
  }

  func attachmentManager(_ manager: AttachmentManager, didReloadTo _: [AttachmentManager.Attachment]) {
    sendButton.isEnabled = manager.attachments.count > 0
  }

  func attachmentManager(_ manager: AttachmentManager, didInsert _: AttachmentManager.Attachment, at _: Int) {
    sendButton.isEnabled = manager.attachments.count > 0
  }

  func attachmentManager(_ manager: AttachmentManager, didRemove _: AttachmentManager.Attachment, at _: Int) {
    sendButton.isEnabled = manager.attachments.count > 0
  }

  func attachmentManager(_: AttachmentManager, didSelectAddAttachmentAt _: Int) {
    showImagePickerControllerActionSheet()
  }

  // MARK: - AttachmentManagerDelegate Helper

  func setAttachmentManager(active: Bool) {
    if active, !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
      topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
      topStackView.layoutIfNeeded()
    } else if !active, topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
      topStackView.removeArrangedSubview(attachmentManager.attachmentView)
      topStackView.layoutIfNeeded()
    }
  }
}

// MARK: UIAdaptivePresentationControllerDelegate

extension CameraInputBarAccessoryView: UIAdaptivePresentationControllerDelegate {
  // Swipe to dismiss image modal
  public func presentationControllerWillDismiss(_: UIPresentationController) {
    isHidden = false
  }
}
