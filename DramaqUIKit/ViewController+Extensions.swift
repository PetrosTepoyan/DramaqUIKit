//
//  ViewController+Extensions.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/6/21.
//

import Foundation
import UIKit

extension ViewController: AddRecordViewDelegate, RecordViewTableCellDelegate, RecordViewAnimationDelegate {
    
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
        let animator = AnimationPatterns.removeAddRecordView
        
        animator.addAnimations {
            self.addRecordView!.center.y = recordViewFrame.midY
            self.addRecordView!.center.x = recordViewFrame.midX
        }
        
        animator.addCompletion { (position) in
            self.addRecordView?.removeFromSuperview()
            self.addRecordView = nil
        }
        
        animator.startAnimation()
        
        
    }
    
    func reconfigureCell(record: Record) {
        
        weak var cell = table.cellForRow(at: indexPathOfSelectedRecord!) as? RecordViewTableCell
        cell!.recordView = nil
        cell!.configure(record: record, recordsTable: table, indexPath: indexPathOfSelectedRecord!)
        cell!.alpha = 0.0
        let animator = AnimationPatterns.addBlurView
        animator.addAnimations {
            self.blurView.alpha = 0.0
        }
        animator.addCompletion { _ in
            self.blurView.removeFromSuperview()
        }
        
        animator.startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell!.alpha = 1.0
            
        }
        
        
    }
    
}
