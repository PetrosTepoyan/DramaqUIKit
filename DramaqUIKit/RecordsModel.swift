//
//  RecordsModel.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/7/21.
//

import UIKit
import CoreData

class RecordsModel: NSObject {
    
    var context: NSManagedObjectContext!
    var dates: [String]! = []
    var data: [[Record]]! = [[]]
    
    typealias RM = RecordsModel
    
    init(context: NSManagedObjectContext) {
        self.context = context

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        request.sortDescriptors = [.init(key: "date", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do {
            var records = try context.fetch(request) as! [Record]
            records.reverse()
            
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
    
    
    
}
