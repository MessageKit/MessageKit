//
//  UICollectionView+Extensions.swift
//  MessageKit
//
//  Created by Frederic Barthelemy on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation

/// Optional Cell Protocol to Simplify registration/cell type loading in a generic way
protocol CollectionViewReusable: class {
	static func reuseIdentifier() -> String
}

extension UICollectionView {
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
}
