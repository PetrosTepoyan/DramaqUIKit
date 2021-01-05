//
//  RecordView.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 12/27/20.
//

import Foundation
import UIKit


open class RecordView: UIView {
    var record: Record
    private let priceLabel: RecordViewLabel
    private var placeLabel: RecordViewLabel
    private let timeLabel: RecordViewLabel
    let hStack = UIStackView()
    private let fontSize: CGFloat = 26
    var hStackYCenter: NSLayoutConstraint!
    var isSquishable: Bool = false
    
    init(record: Record, isSquishable: Bool = false){
        self.record = record
        self.isSquishable = isSquishable
        self.placeLabel = RecordViewLabel(text: record.place ?? "Error")
        self.priceLabel = RecordViewLabel(text: record.price.clean )
        self.timeLabel  = RecordViewLabel(text: (record.date?.getTime())!)
        super.init(frame: CGRect())
        
        prepareView()
        hStackYCenter = self.hStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        hStackYCenter.priority = UILayoutPriority(rawValue: 999)
        setConstraints()
        self.layer.backgroundColor = UIColor(named: record.category!)?.cgColor
        self.layer.cornerRadius = 25
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        self.addSubview(hStack)
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 10
        hStack.addArrangedSubview(priceLabel)
        hStack.addArrangedSubview(placeLabel)
        hStack.addArrangedSubview(timeLabel)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            hStack.heightAnchor.constraint(equalToConstant: 60),
            hStackYCenter
        ])
    
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSquishable {
            let transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            UIView.animate(withDuration: 0.15) {
                self.transform = transform
            }
        }
        
        
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSquishable {
            touchesEnded(touches, with: event)
        }
        
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSquishable {
            let transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.15) {
                self.transform = transform
            }
        }
        
    }
    
    
    
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
