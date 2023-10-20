// MIT License
//
// Copyright (c) 2017-2019 MessageKit
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

import MessageKit
import UIKit

open class CustomCell: UICollectionViewCell {
  // MARK: Lifecycle

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupSubviews()
  }

  // MARK: Open

  open func setupSubviews() {
    contentView.addSubview(label)
    label.textAlignment = .center
    label.font = UIFont.italicSystemFont(ofSize: 13)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    label.frame = contentView.bounds
  }

  open func configure(with message: MessageType, at _: IndexPath, and _: MessagesCollectionView) {
    // Do stuff
    switch message.kind {
    case .custom(let data):
      guard let systemMessage = data as? String else { return }
      label.text = systemMessage
    default:
      break
    }
  }

  // MARK: Internal

  let label = UILabel()
}
