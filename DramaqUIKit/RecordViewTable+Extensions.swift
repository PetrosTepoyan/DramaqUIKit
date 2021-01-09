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
        
        view.addSubview(blurView)
        view.addSubview(recordView)
        
        blurView.alpha = 0.0
        blurView.layer.zPosition = 999
        recordView.isSquishable = false
        recordView.expand()
        recordView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4) {
            self.blurView.alpha = 1.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
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
    
    @objc func closeTap_recordView(_ sender: UITapGestureRecognizer) {
        guard let indexPath = indexPathOfSelectedRecord else { return }
        
        let cell = table.cellForRow(at: indexPath)
        var cellFrame = cell!.frame.offsetBy(dx: 10, dy: 10)
        cellFrame.size.width -= 20
        cellFrame.size.height -= 20
        let rect = table.convert(cellFrame, to: table.superview)
        
        indexPathOfSelectedRecord = nil
        
        self.recordViewHeightAnchor?.constant = rect.height
        self.recordViewYCenter?.constant = rect.midY
        self.mapHeightAnchor?.constant = 0
        self.topMenuStackHeightAnchor?.constant = 0
        self.mapTopAnchor?.constant = 0
        self.topMenuStackTopAnchor?.constant = 5
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: []) {
            self.view.layoutIfNeeded()
            (self.mapHeightAnchor?.firstItem as? MKMapView)?.alpha = 0.0
            (self.topMenuStackHeightAnchor?.firstItem as? UIStackView)?.alpha = 0.0
            self.blurView.alpha = 0.0
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.58) {
            self.view.willRemoveSubview(self.view.subviews.last!)
            self.view.subviews.last!.removeFromSuperview()
            
            self.view.willRemoveSubview(self.blurView)
            self.blurView.removeFromSuperview()
            
            self.view.reloadInputViews()
            let cell = self.table.cellForRow(at: indexPath)
            cell!.alpha = 1.0
            self.table.updateFocusIfNeeded()
            
        }
        
        
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
