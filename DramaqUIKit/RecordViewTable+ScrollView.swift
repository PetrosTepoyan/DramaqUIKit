//
//  RecordViewTable+ScrollView.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 3/7/21.
//

import Foundation
import UIKit

protocol RecordViewScrollingDelegate: class {
    func passYOffsetWhenScrolling(yOffset: CGFloat)
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            recordViewScrollingDelegate?.passYOffsetWhenScrolling(yOffset: scrollView.contentOffset.y)
        }
    }
}
