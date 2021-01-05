//
//  DateHeader.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/4/21.
//

import Foundation
import UIKit

class DateHeader: UIView {
    let title = UILabel()

    init(text: String) {
        title.text = " " + text + " "
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        super.init(frame: CGRect())
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.layer.backgroundColor = UIColor.gray.cgColor
        title.layer.cornerRadius = 15
        title.baselineAdjustment = .alignCenters
        
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 30),
            title.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
//            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
