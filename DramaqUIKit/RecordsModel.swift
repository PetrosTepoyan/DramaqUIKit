//
//  RecordsModel.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/7/21.
//

import UIKit
import CoreData
import SwiftUI

class RecordsModel: NSObject {
    
    var context: NSManagedObjectContext!
    var dates: [String]! = []
    var data: [[Record]]! = [[]]
    private var data_flat: [Record]! = []
    
    typealias RM = RecordsModel
    
    init(context: NSManagedObjectContext) {
        self.context = context

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        request.sortDescriptors = [.init(key: "date", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do {
            var records = try context.fetch(request) as! [Record]
            records.reverse()
            data_flat = records
            
            for date in records.map({ $0.date }) {
                let dateString = date!.getDay()
                if !self.dates.contains(dateString) {
                    self.dates.append(dateString)
                }
            }
            
            self.data = self.dates.map({ dat in records.filter { $0.date?.getDay() == dat } })
            
        } catch { print("Failed") }
        
    }
    
    func add(record: Record) {
        do { try context.save() }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        if dates.isEmpty || dates.first != record.date!.getDay(){
            dates.insert(record.date!.getDay(), at: 0)
            data.insert([record], at: 0)
        } else {
            data[0].insert(record, at: 0)
        }
        
    }
    
    func delete(at indexPath: IndexPath, completion: @escaping () -> ()) {
        
        context.delete(data[indexPath.section][indexPath.row])
        do { try self.context.save() }
        catch { fatalError("Could not delete") }
        data[indexPath.section].remove(at: indexPath.row)
        completion()
    }
    
    func get_ColorsProps() -> [(Color, Double)] {
        let tuples = Category.allCases.map { ($0, 0.0) }
        func countForCategory(_ cat: Category) -> Double {
            return Double(data_flat.filter({ (rec) -> Bool in
                return Category(rawValue: rec.category!) == cat
            }).count / data_flat.count)
        }
        let output = tuples.map({($0.0.color_(), countForCategory($0.0))}).sorted { (v, u) -> Bool in
            v.1 < u.1
        }
        return output
    }
    
    
    
}
