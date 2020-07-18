//
//  ChatView.swift
//  ChatExample
//
//  Created by Kino Roy on 2020-07-18.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import SwiftUI
import MessageKit

@available(iOS 13.0, *)
struct SwiftUIExampleView: View {
    @State var messages = [MessageType]()
    var body: some View {
        MessagesView(messages: $messages).onAppear {
            SampleData.shared.getMessages(count: 20) { messages in
                self.messages.append(contentsOf: messages)
            }
            MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu]).onNewMessage { message in
                self.messages.append(message)
            }
        }.onDisappear {
            MockSocket.shared.disconnect()
        }
        .navigationBarTitle("SwiftUI Example", displayMode: .inline)
    }
}

@available(iOS 13.0.0, *)
struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}
