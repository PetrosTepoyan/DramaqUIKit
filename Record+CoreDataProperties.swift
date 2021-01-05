//
//  Record+CoreDataProperties.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 12/23/20.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var price: Double
    @NSManaged public var place: String?
    @NSManaged public var date: Date?
    @NSManaged public var location: String?
    @NSManaged public var id: UUID?
    @NSManaged public var repetitionPattern: String?
    @NSManaged public var purchaseMethod: String?
    @NSManaged public var category: String?
    @NSManaged public var currency: String?

}

extension Record : Identifiable {

}
