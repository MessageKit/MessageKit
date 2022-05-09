//
//  ChatView.swift
//  ChatExample
//
//  Created by Kino Roy on 2020-07-18.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import SwiftUI
import MessageKit

struct SwiftUIExampleView: View {
    
    @State var messages: [MessageType] = SampleData.shared.getMessages(count: 20)
    
    var body: some View {
        MessagesView(messages: $messages).onAppear {
            self.connectToMessageSocket()
        }.onDisappear {
            self.cleanupSocket()
        }
        .navigationBarTitle("SwiftUI Example", displayMode: .inline)
    }
    
    private func connectToMessageSocket() {
        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu]).onNewMessage { message in
            self.messages.append(message)
        }
    }
    
    private func cleanupSocket() {
        MockSocket.shared.disconnect()
    }
    
}

struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}
