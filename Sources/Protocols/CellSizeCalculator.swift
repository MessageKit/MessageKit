/*
 MIT License

 Copyright (c) 2017-2018 MessageKit

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

import UIKit

/// An object that adopts the `CellSizeCalculator` protocol is responsible for
/// sizing and configuring cells for given `IndexPath`s.
public protocol CellSizeCalculator {

    /// The layout object for which the cell size calculator is used.
    weak var layout: UICollectionViewFlowLayout? { get set }

    /// Used to configure the layout attributes for a given cell.
    ///
    /// - Parameters:
    ///   - attributes: The attributes of the cell.
    func configure(attributes: UICollectionViewLayoutAttributes)

    /// Used to size an item at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` of the item to be displayed.
    func sizeForItem(at indexPath: IndexPath) -> CGSize

}
