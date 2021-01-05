//
//  MapAnnotationPoint.swift
//  Dramaq
//
//  Created by Петрос Тепоян on 12/19/20.
//

import SwiftUI
import MapKit

struct MapAnnotationPoint: Identifiable {
    var id: ObjectIdentifier
    
    
    var record: Record
//    var id: Int
    var location: CLLocationCoordinate2D?
    var title: String
    
    let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    var region: MKCoordinateRegion
    
    init(record: Record) {
        let locationList = record.location?.split(separator: ",").map { Double($0)! }
        self.record = record
//        self.id = Int(record.id)
        self.location = CLLocationCoordinate2D(latitude: locationList![0], longitude: locationList![1])
        self.title = record.place ?? ""
        self.region = MKCoordinateRegion(center: location!, span: span)
        self.id = record.id
    }
    
}

