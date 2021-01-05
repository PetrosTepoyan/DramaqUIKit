//
//  RecordViewTableCell.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/4/21.
//

import Foundation
import UIKit
import MapKit

class RecordViewTableCell: UITableViewCell {
    
    var record: Record!
    var recordView: RecordView!
    let map = MKMapView()
    let topMenuStack = UIStackView()
    let closeButton = UIButton()
    
    var recordViewHeightAnchor: NSLayoutConstraint?
    var recordViewYCenter: NSLayoutConstraint?
    var mapHeightAnchor: NSLayoutConstraint?
    var mapTopAnchor: NSLayoutConstraint?
    var topMenuStackHeightAnchor: NSLayoutConstraint?
    var topMenuStackTopAnchor: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
        contentView.subviews.first?.removeFromSuperview()
    }
    
    
    
}
