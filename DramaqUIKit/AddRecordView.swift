//
//  AddRecordView.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/4/21.
//

import Foundation
import UIKit
import CoreData

protocol AddRecordViewDelegate: class {
    func didFinish()
}

class AddRecordView: UIView {
    let priceTF = UITextField()
    let placeTF = UITextField()
    let draggableLabel = UILabel()
    let contentView = UIView()
    var recordView: RecordView!
    var startingPoint: CGPoint = CGPoint(x: 0, y: 0)
    var record: Record? = nil
    var contentViewBottomAnchor: NSLayoutConstraint?
    
    weak var delegate: AddRecordViewDelegate?
    
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    }()
    
    init() {
        super.init(frame: CGRect.init())
        self.addSubview(contentView)
        self.addSubview(draggableLabel)
        contentView.addSubview(priceTF)
        contentView.addSubview(placeTF)
        
        draggableLabel.layer.zPosition = 10
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        draggableLabel.translatesAutoresizingMaskIntoConstraints = false
        priceTF.translatesAutoresizingMaskIntoConstraints = false
        placeTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            draggableLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            draggableLabel.heightAnchor.constraint(equalToConstant: 60),
            draggableLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            draggableLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            
            priceTF.topAnchor.constraint(equalTo: draggableLabel.bottomAnchor, constant: 30),
            priceTF.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            priceTF.widthAnchor.constraint(equalToConstant: 300),
            priceTF.heightAnchor.constraint(equalToConstant: 80),
            
            placeTF.topAnchor.constraint(equalTo: priceTF.bottomAnchor, constant: 30),
            placeTF.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeTF.widthAnchor.constraint(equalToConstant: 300),
            placeTF.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: draggableLabel.bottomAnchor, constant: 400)
        contentViewBottomAnchor!.isActive = true
        
        draggableLabel.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        draggableLabel.addGestureRecognizer(pan)
        
        contentView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 50
        
        draggableLabel.text = "Drag here"
        draggableLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        draggableLabel.textAlignment = .center
        
        priceTF.layer.cornerRadius = 15
        placeTF.layer.cornerRadius = 15
        
        priceTF.placeholder = "price"
        placeTF.placeholder = "place"
        
        
    }
    
    
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        let home = sender.view?.superview?.parentViewController as! ViewController
        let translation = sender.translation(in: self)
        let draggableLabelBounds = draggableLabel
            .frame
            .offsetBy(dx: translation.x, dy: translation.y)
            .offsetBy(dx: 10, dy: 10)
        
        
        switch sender.state {
        case .began:
            self.startingPoint = home.addRecordViewCenter!
            
        case .changed:
            UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.67) {
                self.center.x = self.startingPoint.x + translation.x
                self.center.y = self.startingPoint.y + translation.y
            }.startAnimation()
            
            if home.addRecordSuccessFrame.intersects(draggableLabelBounds) {
                
                if record == nil {
                    record = Record(usedContext: home.context)
                    record!.id = UUID()
                    record!.price = Double(priceTF.text ?? "0.0") ?? 0.0
                    record!.place = placeTF.text
                    record!.location = "51.507222,-0.1275"
                    record!.date = Date()
                    record!.category = Category.allCases.randomElement()!.rawValue
                    record!.purchaseMethod = "Card"
                    
                    recordView = RecordView(record: record!)
                    recordView.translatesAutoresizingMaskIntoConstraints = false
                    recordView.alpha = 0.0
                    recordView.layer.zPosition = draggableLabel.layer.zPosition + 1
                    self.addSubview(recordView)
                    NSLayoutConstraint.activate([
                        recordView.widthAnchor.constraint(equalTo: home.table.widthAnchor, constant: -20),
                        recordView.heightAnchor.constraint(equalToConstant: 70),
                        recordView.centerYAnchor.constraint(equalTo: draggableLabel.centerYAnchor),
                        recordView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                    ])
                    superview?.layoutIfNeeded()
                }
                
                UIView.animate(withDuration: 0.5) { [self] in
                    recordView.alpha = 1.0
                    priceTF.alpha = 0.0
                    placeTF.alpha = 0.0
                    contentView.alpha = 0.0
                    home.view.layoutIfNeeded()
                }
            }
            
            if !home.addRecordDismissFrame.intersects(draggableLabelBounds) &&
                !home.addRecordSuccessFrame.intersects(draggableLabelBounds) {
                UIView.animate(withDuration: 0.5) { [self] in
//                    contentViewBottomAnchor?.constant = 400
                    recordView?.alpha = 0.0
                    priceTF.alpha = 1.0
                    placeTF.alpha = 1.0
                    contentView.alpha = 1.0
                    recordView = nil
                    record = nil
                    home.view.layoutIfNeeded()
                }
            }
            
            
        case .ended:
            
            if home.addRecordDismissFrame.intersects(draggableLabelBounds) {
                delegate?.didFinish()
                
            } else if home.addRecordSuccessFrame.intersects(draggableLabelBounds) {
                if home.model.data.count != 0 {
                    home.table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                
                home.model.add(record: record!)
                
                if home.model.data[0].count == 1 { // means that the record with new date has just been added
                    home.table.insertSections(IndexSet(0...0), with: .bottom)
                    
                } else {
                    home.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
                }
                let cell = home.table.cellForRow(at: IndexPath(row: 0, section: 0))
                cell?.alpha = 0.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + AnimationPatterns.removeAddRecordView.duration - 0.05) {
                    cell?.alpha = 1.0
                }
                
                delegate?.didFinish()
                return 
                
            } else {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: []) {
                    home.addRecordView!.center.x = home.view.center.x
                    home.addRecordView!.center.y = home.view.center.y
                } completion: { (done) in
                    
                }
            }
            
            
            
        default:
            ()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}


import CoreData

public extension NSManagedObject {
    
    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
    
}
