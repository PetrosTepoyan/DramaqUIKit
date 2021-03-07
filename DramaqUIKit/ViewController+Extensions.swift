//
//  ViewController+Extensions.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/6/21.
//

import Foundation
import UIKit

extension ViewController: AddRecordViewDelegate, RecordViewTableCellDelegate, RecordViewAnimationDelegate {
    
    func animateTransition(recordToPass: Record) {
        if model.data.count != 0 {
            table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        model.add(record: recordToPass)
        
        if model.data[0].count == 1 { // means that the record with new date has just been added
            table.insertSections(IndexSet(0...0), with: .bottom)
            
        } else {
            table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        }
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0))
        cell?.alpha = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationPatterns.recordView.duration + AnimationPatterns.delta) {
            cell?.alpha = 1.0
        }
    }
    
    
    
    func getRectForCell(indexPath: IndexPath) -> CGRect {
        return table.rectForRow(at: indexPath)
    }
    
    
    func didFinish() {
        let topIndex = IndexPath(row: 0, section: 0)
        let cell = table.cellForRow(at: topIndex) as! RecordViewTableCell
        var recordViewFrame = cell.recordView!.frame
        recordViewFrame = table.rectForRow(at: topIndex)
        recordViewFrame.size.width -= 20
        recordViewFrame.size.height -= 20
        recordViewFrame = recordViewFrame.offsetBy(dx: 10, dy: 5) //??
        recordViewFrame = table.convert(recordViewFrame, to: view)
        
        self.addRecordView!.frame.size.height = 70
        let animator = AnimationPatterns.addRecordView
        
        animator.addAnimations {
            self.addRecordView!.center.y = recordViewFrame.midY
            self.addRecordView!.center.x = recordViewFrame.midX
            self.toggleBlurView()
        }
        
        animator.addCompletion { (position) in
            self.addRecordView?.removeFromSuperview()
            self.addRecordView = nil
        }
        
        animator.startAnimation()
        
        
    }
    
    func reconfigureCell(record: Record) {
//        recordViewScrollingDelegate
        cellToReconfigure = table.cellForRow(at: indexPathOfSelectedRecord!) as? RecordViewTableCell
        cellToReconfigure!.recordView = nil
        cellToReconfigure!.configure(record: record, recordsTable: table, indexPath: indexPathOfSelectedRecord!)
        cellToReconfigure!.alpha = 0.0
        
        let blurAnimator = AnimationPatterns.addBlurView
        blurAnimator.addAnimations {
            self.toggleBlurView()
        }
        blurAnimator.startAnimation()
        
        
    }
    
    func passRecordViewAnimator(rvAnimator: UIViewPropertyAnimator) {
        rvAnimator.addCompletion { (position) in
            if position == .end {
                self.cellToReconfigure!.alpha = 1.0
            }
        }
    }
    
    
    
}
