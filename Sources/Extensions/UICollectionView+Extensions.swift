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

import Foundation

/// Optional Cell Protocol to Simplify registration/cell type loading in a generic way
public protocol CollectionViewReusable: AnyObject {
    static func reuseIdentifier() -> String
}

public extension MessagesCollectionView {
    /// Registers a particular cell using its reuse-identifier
    func register<CellType: UICollectionViewCell & CollectionViewReusable>(_ cellClass: CellType.Type) {
	    register(cellClass, forCellWithReuseIdentifier: CellType.reuseIdentifier())
    }

    /// Registers a reusable view for a specific SectionKind
    func register<ViewType: UICollectionReusableView & CollectionViewReusable>(_ headerFooterClass: ViewType.Type, forSupplementaryViewOfKind kind: String) {
	    register(headerFooterClass,
	             forSupplementaryViewOfKind: kind,
	             withReuseIdentifier: ViewType.reuseIdentifier())
    }

    /// Generically dequeues a cell of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
    func dequeueReusableCell<CellType: UICollectionViewCell & CollectionViewReusable>(_ cellClass: CellType.Type, for indexPath: IndexPath) -> CellType {
	    guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier(), for: indexPath) as? CellType else {
    	    fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(cellClass.reuseIdentifier())")
	    }
	    return cell
    }

    /// Generically dequeues a header of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
    func dequeueReusableHeaderView<ViewType: UICollectionReusableView & CollectionViewReusable>(_ viewClass: ViewType.Type, for indexPath: IndexPath) -> ViewType {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: viewClass.reuseIdentifier(), for: indexPath)
        guard let viewType = view as? ViewType else {
            fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(viewClass.reuseIdentifier())")
        }
        return viewType
    }

    /// Generically dequeues a footer of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
    func dequeueReusableFooterView<ViewType: UICollectionReusableView & CollectionViewReusable>(_ viewClass: ViewType.Type, for indexPath: IndexPath) -> ViewType {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: viewClass.reuseIdentifier(), for: indexPath)
        guard let viewType = view as? ViewType else {
            fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(viewClass.reuseIdentifier())")
        }
        return viewType
    }
}
