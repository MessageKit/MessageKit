// MIT License
//
// Copyright (c) 2017-2026 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Created by Kino Roy on 2020-07-18.

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
    // Fixes the InputBarAccessoryView placement when the keyboard appears
    .ignoresSafeArea(.keyboard, edges: .bottom)
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
