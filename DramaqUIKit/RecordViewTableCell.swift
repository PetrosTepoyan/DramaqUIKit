//
//  RecordViewTableCell.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/4/21.
//

import Foundation
import UIKit
import MapKit

protocol RecordViewTableCellDelegate {
    func getRectForCell(indexPath: IndexPath) -> CGRect
    
}

private enum State {
    case expanded
    case collapsed
    
    var change: State {
        switch self {
        case .expanded: return .collapsed
        case .collapsed: return .expanded
        }
    }
}


class RecordViewTableCell: UITableViewCell {
    
    var record: Record!
    weak var recordView: RecordView?
    var tableView: UITableView!
    
    var delegate: RecordViewTableCellDelegate?
    
    var map: MKMapView {
        let map = MKMapView()
        map.layer.cornerRadius = 25
        map.layer.borderWidth = 1
        map.alpha = 0.0
        map.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        map.isScrollEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }
    
    var topMenuStack: UIStackView {
        let topMenuStack = UIStackView()
        topMenuStack.alpha = 0.0
        topMenuStack.axis = .horizontal
        topMenuStack.translatesAutoresizingMaskIntoConstraints = false
        
        return topMenuStack
    }
    
    var closeButton: UIButton {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButton.frame.size = CGSize(width: 30, height: 30)
        closeButton.tintColor = UIColor.black.withAlphaComponent(0.3)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        closeButton.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        
        return closeButton
    }
    
    var dateLabel: UILabel {
        let dateLabel = UILabel()
        dateLabel.text = record.date?.getDayExpExp()
        dateLabel.font = UIFont(name: "Avenir", size: 19)!
        
        return dateLabel
    }
    
    var recordViewHeightAnchor: NSLayoutConstraint?
    var recordViewYCenter: NSLayoutConstraint?
    var recordViewXCenter: NSLayoutConstraint?
    var mapHeightAnchor: NSLayoutConstraint?
    var mapTopAnchor: NSLayoutConstraint?
    var topMenuStackHeightAnchor: NSLayoutConstraint?
    var topMenuStackTopAnchor: NSLayoutConstraint?
    var indexPath: IndexPath!
    
    private var animationProgress: CGFloat = 0
    
    private var initialFrame: CGRect?
    private lazy var animator: UIViewPropertyAnimator = {
        let springTiming = UISpringTimingParameters(mass: 1.0,
                                                    stiffness: 2.0,
                                                    damping: 0.2,
                                                    initialVelocity: .zero)
        
        return UIViewPropertyAnimator(duration: 0.3, timingParameters: springTiming)
    }()
    
    private let cornerRadius: CGFloat = 25
    static let identifier = TableViewIds.recordViewCell.rawValue
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
        contentView.subviews.first?.removeFromSuperview()
    }
    
    func configure(recordView: RecordView, recordsTable: UITableView, indexPath: IndexPath) {
        if self.recordView == nil {
            self.recordView = recordView
        }
        self.recordView!.delegate = parentViewController! as? RecordViewAnimationDelegate
        
        recordView.layer.cornerRadius = cornerRadius
        
        self.contentView.addSubview(recordView)
        self.tableView = recordsTable
        recordView.translatesAutoresizingMaskIntoConstraints = false
        recordViewYCenter = recordView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        recordViewHeightAnchor = recordView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
        recordViewHeightAnchor?.priority = 999.0
        recordViewXCenter = recordView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([
            recordView.widthAnchor.constraint(equalToConstant: recordsTable.frame.width - 20),
            recordViewXCenter!,
            recordViewYCenter!,
            recordViewHeightAnchor!
//            recordView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
//            recordView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(record: Record, recordsTable: UITableView, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.record = record
        let recordView = RecordView(record: record,
                                isSquishable: true)
        self.recordView = recordView
        configure(recordView: recordView, recordsTable: recordsTable, indexPath: indexPath)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
}
