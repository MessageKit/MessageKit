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

extension MessagesViewController: UIScrollViewDelegate {
  open func scrollViewDidScroll(_: UIScrollView) { }
  open func scrollViewWillBeginDragging(_: UIScrollView) { }
  open func scrollViewWillEndDragging(
    _: UIScrollView,
    withVelocity _: CGPoint,
    targetContentOffset _: UnsafeMutablePointer<CGPoint>) { }
  open func scrollViewDidEndDragging(_: UIScrollView, willDecelerate _: Bool) { }
  open func scrollViewWillBeginDecelerating(_: UIScrollView) { }
  open func scrollViewDidEndDecelerating(_: UIScrollView) { }
  open func scrollViewDidEndScrollingAnimation(_: UIScrollView) { }
  open func scrollViewDidScrollToTop(_: UIScrollView) { }
  open func scrollViewDidChangeAdjustedContentInset(_: UIScrollView) { }
}
