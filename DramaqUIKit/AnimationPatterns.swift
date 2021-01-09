//
//  AnimationPatterns.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/9/21.
//

import Foundation
import UIKit

enum AnimationPatterns {
    static var removeAddRecordView = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.8)
    static var addBlurView         = UIViewPropertyAnimator(duration: 0.4, curve: .linear)
    static var recordView          = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.8)
}
