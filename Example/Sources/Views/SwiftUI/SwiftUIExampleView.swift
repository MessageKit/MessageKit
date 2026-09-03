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
      connectToMessageSocket()
    }.onDisappear {
      cleanupSocket()
    }
    .navigationBarTitle("SwiftUI Example", displayMode: .inline)
    /// `MessagesViewController` pins its collection view and its input bar to
    /// `view.bottomAnchor`, and the keyboard manager places the input bar a
    /// whole keyboard height above that anchor. So the view has to reach the
    /// bottom of the screen: leave the home indicator inset in place and the
    /// bar settles that inset above the keyboard instead of on top of it.
    /// Ignoring `.keyboard` alone is not enough, because that region covers
    /// only the keyboard.
    .ignoresSafeArea(edges: .bottom)
  }

  // MARK: Private

  private func connectToMessageSocket() {
    MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu]).onNewMessage { message in
      messages.append(message)
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
