//
//  AddRecordViewTextField.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 3/6/21.
//

import UIKit

class AddRecordViewTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont.preferredFont(forTextStyle: .title1)
        setupLayer()
        setupLeftView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayer() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize.zero
    }
    
    func setupLeftView() {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        leftViewMode = .always
        
        
        leftView!.backgroundColor = .black
//        drawPlaceholder(in: CGRect(x: 10, y: 0, width: 10, height: 0))
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
    
    
}
