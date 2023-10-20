//
//  ChatView.swift
//  ChatExample
//
//  Created by Kino Roy on 2020-07-18.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import MessageKit
import SwiftUI

// MARK: - SwiftUIExampleView

struct SwiftUIExampleView: View {
  // MARK: Internal

  @State var messages: [MessageType] = SampleData.shared.getMessages(count: 20)

  var body: some View {
    MessagesView(messages: $messages).onAppear {
      self.connectToMessageSocket()
    }.onDisappear {
      self.cleanupSocket()
    }
    .navigationBarTitle("SwiftUI Example", displayMode: .inline)
    .modifier(IgnoresSafeArea()) //fixes issue with IBAV placement when keyboard appears
  }

  // MARK: Private
    
  private struct IgnoresSafeArea: ViewModifier {
      func body(content: Content) -> some View {
          if #available(iOS 14.0, *) {
              content.ignoresSafeArea(.keyboard, edges: .bottom)
          } else {
              content
          }
      }
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

// MARK: - SwiftUIExampleView_Previews

struct SwiftUIExampleView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIExampleView()
  }
}
