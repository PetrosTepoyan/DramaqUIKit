//
//  NSLayoutConstraint+Extension.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/8/21.
//

import Foundation
import UIKit

extension UILayoutPriority: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(Float(value))
        
      }
    
}
