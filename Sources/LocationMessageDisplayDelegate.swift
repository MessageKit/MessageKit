//
//  LocationMessageDisplayDelegate.swift
//  MessageKit
//
//  Created by Eduardo Toledo on 9/22/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation
import MapKit

public protocol LocationMessageDisplayDelegate: MessagesDisplayDelegate {
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions

    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView

}

public extension LocationMessageDisplayDelegate {

    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        return LocationMessageSnapshotOptions()
    }

    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView {
        return MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
    }

}
