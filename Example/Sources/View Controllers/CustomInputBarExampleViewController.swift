// MIT License
//
// Copyright (c) 2017-2022 MessageKit
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

import Foundation
import UIKit

final class CustomInputBarExampleViewController: BasicExampleViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let customInputView = UIView()
    customInputView.backgroundColor = .secondarySystemBackground
    let customLabel = UILabel()
    customLabel.translatesAutoresizingMaskIntoConstraints = false
    customLabel.font = .preferredFont(forTextStyle: .headline)
    customLabel.textAlignment = .center
    customLabel.text = "This chat is read only."
    customLabel.textColor = .primaryColor
    customInputView.addSubview(customLabel)

    NSLayoutConstraint.activate([
      customLabel.topAnchor.constraint(equalTo: customInputView.topAnchor, constant: 16),
      customLabel.bottomAnchor.constraint(equalTo: customInputView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      customLabel.leadingAnchor.constraint(equalTo: customInputView.leadingAnchor),
      customLabel.trailingAnchor.constraint(equalTo: customInputView.trailingAnchor),
    ])

    inputBarType = .custom(customInputView)
  }
}
