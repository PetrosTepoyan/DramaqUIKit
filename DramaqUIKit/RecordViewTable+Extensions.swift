//
//  RecordViewTable+Extensions.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/4/21.
//

import Foundation
import UIKit
import MapKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {   // Number of Secions
        return model.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return DateHeader(text: model.dates[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIds.recordViewCell.rawValue, for: indexPath) as! RecordViewTableCell
        let record = self.model.data[indexPath.section][indexPath.row]
        cell.configure(record: record, recordsTable: tableView, indexPath: indexPath)
        cell.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap_recordView(_:)))
        cell.addGestureRecognizer(tap)
        
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.recordView!.addInteraction(interaction)
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath) as! RecordViewTableCell
        let recordView = cell.recordView!
        recordView.translatesAutoresizingMaskIntoConstraints = true
        recordView.frame = tableView.rectForRow(at: indexPath)
        recordView.frame.size.width -= 20
        recordView.frame.size.height -= 20
        recordView.frame = recordView.frame.offsetBy(dx: 10, dy: 10)
        recordView.frame = table.convert(recordView.frame, to: view)
        recordView.layer.zPosition = 1000
        recordViewScrollingDelegate = recordView
        view.addSubview(recordView)
        
        recordView.isSquishable = false
        recordView.expand()
        recordView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4) {
            self.toggleBlurView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    @objc func tap_recordView(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UITableViewCell else { return }
        let indexPath = table.indexPath(for: cell)
        indexPathOfSelectedRecord = indexPath
        tableView(table, didSelectRowAt: indexPath!)
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            action.backgroundColor = .red
            self.model.delete(at: indexPath) {
                self.removeRecordFromTable(indexPath)
            }
            
            completionHandler(true)
            
        }
        
        delete.image = UIImage(systemName: "trash")!.withTintColor(.red, renderingMode: .alwaysOriginal)
        delete.title = nil
        delete.backgroundColor = .white
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            action.backgroundColor = .red
            print("index path of edit: \(indexPath)")
            completionHandler(true)
        }
        
        rename.image = UIImage(systemName: "square.and.pencil")!.withTintColor(.systemPurple, renderingMode: .alwaysOriginal)
        rename.title = nil
        rename.backgroundColor = .white
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    func removeRecordFromTable(_ indexPath: IndexPath) {
        if self.model.data[0].count == 0 {
            if self.model.data[indexPath.section].isEmpty {
                self.model.data.remove(at: indexPath.section)
                self.model.dates.remove(at: indexPath.section)
            }
            self.table.deleteSections(IndexSet(indexPath.section...indexPath.section), with: .fade)
            
        } else {
            self.table.deleteRows(at: [indexPath], with: .left)
        }
    }
    
}

enum TableViewIds: String {
    case recordViewCell
}
