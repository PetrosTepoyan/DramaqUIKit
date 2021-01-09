////
////  DraggableLabel.swift
////  DramaqUIKit
////
////  Created by Петрос Тепоян on 1/4/21.
////
//
//import Foundation
//import UIKit
//
//class DraggableView: UIView {
//    let draggableLabel = UILabel()
//    
//    
//    init() {
//        super.init(frame: CGRect.init())
//        
//        draggableLabel.text = "Drag here"
//        draggableLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            draggableLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            draggableLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            draggableLabel.heightAnchor.constraint(equalTo: heightAnchor),
//            draggableLabel.widthAnchor.constraint(equalTo: widthAnchor)
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
