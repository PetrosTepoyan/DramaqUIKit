//
//  ViewController+Extensions.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/6/21.
//

import Foundation
import UIKit

extension ViewController: AddRecordViewDelegate {
    func didFinish() {
        addRecordView.removeFromSuperview()
    }
}
