//
//  RecordViewLabel.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/1/21.
//

import Foundation
import UIKit

class RecordViewLabel: UILabel {
    var fontSize: CGFloat
    
    init(text: String, fontSize: CGFloat = 26) {
        self.fontSize = fontSize
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        self.text = text
        self.textColor = .black
        self.font = UIFont(name: "Avenir", size: fontSize)!
        self.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


