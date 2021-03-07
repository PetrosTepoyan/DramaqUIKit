//
//  AnimationPatterns.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/9/21.
//

import Foundation
import UIKit

var debugAnimations: Bool = false

enum AnimationPatterns {
    
    static var addRecordView       = UIViewPropertyAnimator(duration: 0.7 * (debugAnimations ? 10 : 1),
                                                            dampingRatio: 0.8)
    
    static var addBlurView         = UIViewPropertyAnimator(duration: 0.2 * (debugAnimations ? 10 : 1),
                                                            curve: .linear)
    
    static var recordView          = UIViewPropertyAnimator(duration: 0.6 * (debugAnimations ? 30 : 1),
                                                            dampingRatio: 0.8)
    
    static var delta = 0.7
}
