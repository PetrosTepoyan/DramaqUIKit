//
//  Record.swift
//  MoneyTrackerNotFinal
//
//  Created by Петрос Тепоян on 11/1/20.
//  Copyright © 2020 Петрос Тепоян. All rights reserved.
//

import UIKit
import MapKit

enum PurchaseMethod: String {
    case cash
    case card
}

enum Badge: String {
    case RepetitiveBadge
    case CardBadge
    case CashBadge
}

//struct Record: Hashable, Identifiable{
//    var id: Int
//    var price: Double
//    var place: String
//    var date: Date
//    var category: Category
//    var keywords: [String]?
//    var currency: String?
////    var nextTimeStamp: Date?
//    var repeatsEachTimeInterval: Double?
//    var purchaseMethod: PurchaseMethod?
//     
//    var location: CLLocationCoordinate2D?
//    
//    func hash(into hasher: inout Hasher) {
//        return
//    }
//    
//    static func == (lhs: Record, rhs: Record) -> Bool {
//        return false
//    }
//}


