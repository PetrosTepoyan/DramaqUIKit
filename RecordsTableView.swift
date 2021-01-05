////
////  RecordsTableView.swift
////  DramaqUIKit
////
////  Created by Петрос Тепоян on 1/5/21.
////
//
//import Foundation
//import UIKit
//
//class RecordsTable : UITableView, UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {   // Number of Secions
//        return records_2d.count
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return DateHeader(text: dates[section])
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return records_2d[section].count
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIds.recordViewCell.rawValue, for: indexPath) as! RecordViewTableCell
//
//        let recordView = RecordView(record: records_2d[indexPath.section][indexPath.row], isSquishable: true)
//        
////
//        cell.contentView.addSubview(recordView)
//        recordView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            recordView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
//            recordView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
//            recordView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
//            recordView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
//        ])
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tap_recordView))
//        cell.addGestureRecognizer(tap)
//        
//        return cell
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! RecordViewTableCell
////        cell.close(self)
////        let cell = tableView.cellForRow(at: indexPath)
//        var cellFrame = cell.frame.offsetBy(dx: 10, dy: 0)
//        cellFrame.size.width -= 20
//        let rect = tableView.convert(cellFrame, to: tableView.superview)
//        cell.alpha = 0.0
//        
//        view.addSubview(blurView)
//        blurView.alpha = 0.0
//        
//        let record = data[indexPath.item]
//        let recordView = RecordView(record: record)
//        view.addSubview(recordView)
//        recordView.layer.zPosition = 3
//        
//        self.recordViewHeightAnchor = recordView.heightAnchor.constraint(equalToConstant: rect.height)
//        self.recordViewYCenter = recordView.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: rect.midY)
//        
//        
//        let map = MKMapView()
//        recordView.addSubview(map)
//        map.layer.cornerRadius = 25
//        map.layer.borderWidth = 1
//        map.alpha = 0.0
//        map.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        map.isScrollEnabled = false
//        map.translatesAutoresizingMaskIntoConstraints = false
//        self.mapHeightAnchor = map.heightAnchor.constraint(equalToConstant: 0)
//        self.mapTopAnchor = map.topAnchor.constraint(equalTo: recordView.subviews[0].bottomAnchor, constant: 10)
//        
//        let topMenuStack = UIStackView()
//        topMenuStack.alpha = 0.0
//        recordView.addSubview(topMenuStack)
//        topMenuStack.axis = .horizontal
//        topMenuStack.translatesAutoresizingMaskIntoConstraints = false
//        self.topMenuStackHeightAnchor = topMenuStack.heightAnchor.constraint(equalToConstant: 0)
//        self.topMenuStackTopAnchor = topMenuStack.topAnchor.constraint(equalTo: recordView.topAnchor, constant: 10)
//        
//        let dateLabel = UILabel()
//        dateLabel.text = record.date?.getDayExpExp()
//        dateLabel.font = UIFont(name: "Avenir", size: 19)!
//        topMenuStack.addArrangedSubview(dateLabel)
//        
//        let closeButton = UIButton()
//        closeButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
//        closeButton.frame.size = CGSize(width: 30, height: 30)
//        closeButton.tintColor = UIColor.black.withAlphaComponent(0.3)
//        closeButton.addTarget(self, action: #selector(closeTap_recordView), for: .touchUpInside)
//        topMenuStack.addArrangedSubview(closeButton)
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        closeButton.trailingAnchor.constraint(equalTo: topMenuStack.trailingAnchor).isActive = true
//        closeButton.heightAnchor.constraint(equalTo: topMenuStack.heightAnchor).isActive = true
//        
//        recordView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            recordView.widthAnchor.constraint(equalToConstant: rect.width),
//            recordView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
//            self.recordViewYCenter!,
//            self.recordViewHeightAnchor!,
//            
//            recordView.subviews[0].topAnchor.constraint(equalTo: topMenuStack.bottomAnchor),
//            
//            map.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10),
//            map.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10),
//            self.mapTopAnchor!,
//            self.mapHeightAnchor!,
//            
//            topMenuStack.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10),
//            topMenuStack.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10),
//            self.topMenuStackTopAnchor!,
//            self.topMenuStackHeightAnchor!
//        ])
//        
//        self.view.layoutIfNeeded()
//        
//        recordViewHeightAnchor!.constant   = 400
//        recordViewYCenter!.constant        = self.view.frame.midY
//        mapHeightAnchor!.constant          = 240
//        topMenuStackHeightAnchor!.constant = 30
//        recordView.hStackYCenter           = nil
//        
//        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.8) {
//            self.blurView.alpha = 1.0
//            self.view.layoutIfNeeded()
//        }
//        
//        animator.addAnimations({
//            map.alpha = 1.0
//            topMenuStack.alpha = 1.0
//        }, delayFactor: 0.1)
//        
//        animator.startAnimation()
//    }
//    
//    @objc func tap_recordView(_ sender: UITapGestureRecognizer) {
//        guard let cell = sender.view as? UITableViewCell else { return }
//        let indexPath = table.indexPath(for: cell)
//        indexPathOfSelectedRecord = indexPath
//        tableView(table, didSelectRowAt: indexPath!)
//    }
//    
//    @objc func closeTap_recordView(_ sender: UITapGestureRecognizer) {
//        guard let indexPath = indexPathOfSelectedRecord else { return }
//        
//        let cell = table.cellForRow(at: indexPath)
//        var cellFrame = cell!.frame.offsetBy(dx: 10, dy: 10)
//        cellFrame.size.width -= 20
//        cellFrame.size.height -= 20
//        let rect = table.convert(cellFrame, to: table.superview)
//        
//        indexPathOfSelectedRecord = nil
//        
//        self.recordViewHeightAnchor?.constant = rect.height
//        self.recordViewYCenter?.constant = rect.midY
//        self.mapHeightAnchor?.constant = 0
//        self.topMenuStackHeightAnchor?.constant = 0
//        self.mapTopAnchor?.constant = 0
//        self.topMenuStackTopAnchor?.constant = 5
//        
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: []) {
//            self.view.layoutIfNeeded()
//            (self.mapHeightAnchor?.firstItem as? MKMapView)?.alpha = 0.0
//            (self.topMenuStackHeightAnchor?.firstItem as? UIStackView)?.alpha = 0.0
//            self.blurView.alpha = 0.0
//        }
//        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.58) {
//            self.view.willRemoveSubview(self.view.subviews.last!)
//            self.view.subviews.last!.removeFromSuperview()
//            
//            self.view.willRemoveSubview(self.blurView)
//            self.blurView.removeFromSuperview()
//            
//            self.view.reloadInputViews()
//            let cell = self.table.cellForRow(at: indexPath)
//            cell!.alpha = 1.0
//            self.table.updateFocusIfNeeded()
//            
//        }
//        
//        
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
//            print("index path of delete: \(indexPath)")
//            completionHandler(true)
//            
//        }
//
//        delete.image = UIImage(systemName: "trash")!.withTintColor(.red, renderingMode: .alwaysOriginal)
//        delete.title = nil
////        delete.image.
//        delete.backgroundColor = .white
//        
//        
//        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
//            print("index path of edit: \(indexPath)")
//            completionHandler(true)
//        }
//        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
//        swipeActionConfig.performsFirstActionWithFullSwipe = false
//        return swipeActionConfig
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            context.delete(records_2d[indexPath.section][indexPath.row])
//            
//            do {
//                try context.save()
//            } catch {
//                fatalError("Could not delete")
//            }
//            
//            records_2d[indexPath.section].remove(at: indexPath.row)
//            if records_2d[indexPath.section].isEmpty { records_2d.remove(at: indexPath.section) }
//            UIView.transition(with: table,
//                              duration: 0.35,
//                              options: [.preferredFramesPerSecond60, .transitionCrossDissolve, .curveEaseInOut],
//                              animations: {
//                                self.table.reloadData()
//
//                              })
//            
//        }
//    }
//}
