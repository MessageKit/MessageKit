/*
 MIT License

 Copyright (c) 2017-2022 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import UIKit
import Combine
import InputBarAccessoryView

final class InputAccessoryKeyboardObservingView: UIView {

    // MARK: - Public properties

    @available(iOS 13.0, *)
    @Published private(set) var keyboardNotification: KeyboardNotification?

    // MARK: - Private properties

    @available(iOS 13, *)
    private lazy var disposeBag: Set<AnyCancellable> = Set()

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        autoresizingMask = .flexibleHeight
        if #available(iOS 13, *) {
            setupObservers()
        }
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Private methods

    @available(iOS 13, *)
    private func setupObservers() {
        Publishers.MergeMany(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
            NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification),
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
            NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
        )
        .subscribe(on: DispatchQueue.global())
        .map { $0 as NSNotification }
        .compactMap(KeyboardNotification.init(from:))
        .assign(to: \.keyboardNotification, on: self)
        .store(in: &disposeBag)
    }
}
