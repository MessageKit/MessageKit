//
//  MessagesView.swift
//  ChatExample
//
//  Created by Kino Roy on 2020-07-18.
//  Copyright © 2020 MessageKit. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI
import MessageKit

class MessageSwiftUIVC: MessagesViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
}

@available(iOS 13.0.0, *)
struct MessagesView: UIViewControllerRepresentable {
    
    @Binding var messages: [MessageType]
    
    func makeUIViewController(context: Context) -> MessagesViewController {
        let messagesVC = MessageSwiftUIVC()
        
        messagesVC.messagesCollectionView.messagesDisplayDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesLayoutDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesDataSource = context.coordinator
        
        return messagesVC
    }
    
    func updateUIViewController(_ uiViewController: MessagesViewController, context: Context) {
        if !uiViewController.isFirstResponder {
            uiViewController.becomeFirstResponder()
        }
        uiViewController.messagesCollectionView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(messages: $messages)
    }
    
    final class Coordinator {
        var messages: Binding<[MessageType]>
        init(messages: Binding<[MessageType]>) {
            self.messages = messages
        }
    }

}

@available(iOS 13.0.0, *)
extension MessagesView.Coordinator: MessagesDataSource {
    func currentSender() -> SenderType {
        return MockUser(senderId: "", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages.wrappedValue[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.wrappedValue.count
    }
}

@available(iOS 13.0.0, *)
extension MessagesView.Coordinator: MessagesLayoutDelegate, MessagesDisplayDelegate {
    
}

@available(iOS 13.0.0, *)
struct MessageViewPreviewWrapper: View {
    @State var messages = [MessageType]()
    var body: some View {
        MessagesView(messages: $messages).onAppear {
            SampleData.shared.getMessages(count: 20) { messages in
                self.messages.append(contentsOf: messages)
            }
        }
    }
}

@available(iOS 13.0.0, *)
struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessageViewPreviewWrapper()
    }
}

#endif
