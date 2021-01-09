//
//  RecordView.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 12/27/20.
//

import Foundation
import UIKit
import MapKit

protocol RecordViewAnimationDelegate: class {
    func reconfigureCell(record: Record)
}

open class RecordView: UIView {
    
    enum State {
        case expanded
        case collapsed
    }
    var state: State = .collapsed
    
    weak var record: Record?
    private let priceLabel: RecordViewLabel
    private var placeLabel: RecordViewLabel
    private let timeLabel: RecordViewLabel
    let hStack = UIStackView()
    private let fontSize: CGFloat = 26
    weak var delegate: RecordViewAnimationDelegate?
    
    
    var hStackYCenter: NSLayoutConstraint!
    var hStackTopAnchor: NSLayoutConstraint!
    var scrollViewHeightAnchor: NSLayoutConstraint!
    var scrollViewTopAnchor: NSLayoutConstraint!
    var topMenuStackHeightAnchor: NSLayoutConstraint!
    var topMenuStackTopAnchor: NSLayoutConstraint!
    
    var isSquishable: Bool = false
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var map: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 25
        map.layer.borderWidth = 1
        map.alpha = 0.0
        map.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        //        map.isScrollEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        let point = MKPointAnnotation()
        point.title = "Pin"
        point.coordinate = record!.getLocation()
        map.addAnnotation(point)
        map.region.center = point.coordinate
        map.region.span.latitudeDelta  = 0.05
        map.region.span.longitudeDelta = 0.05
        return map
    }()
    lazy var topMenuStack: UIStackView = {
        let topMenuStack = UIStackView()
        topMenuStack.alpha = 0.0
        topMenuStack.axis = .horizontal
        topMenuStack.translatesAutoresizingMaskIntoConstraints = false
        return topMenuStack
    }()
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = record!.date?.getDayExpExp()
        dateLabel.font = UIFont(name: "Avenir", size: 19)!
        return dateLabel
    }()
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        
        let config = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        var image = UIImage(systemName: "x.circle.fill", withConfiguration: config)
        image = image?.aspectFittedToHeight(30)
        closeButton.setImage(image, for: .normal)
        closeButton.frame.size = CGSize(width: 30, height: 30)
        closeButton.tintColor = UIColor.black.withAlphaComponent(0.3)
        closeButton.addTarget(self, action: #selector(collapse), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    lazy var animator: UIViewPropertyAnimator = {
        let animator = AnimationPatterns.recordView
        animator.addAnimations {
            self.layoutIfNeeded()
        }
        return animator
    }()
    
    var initialFrame: CGRect?
    
    init(record: Record, isSquishable: Bool = false){
        self.record = record
        self.isSquishable = isSquishable
        self.placeLabel = RecordViewLabel(text: record.place ?? "Error")
        self.priceLabel = RecordViewLabel(text: record.price.clean )
        self.timeLabel  = RecordViewLabel(text: (record.date?.getTime())!)
        super.init(frame: CGRect())
        
        prepareView()
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
        hStackYCenter = self.hStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        hStackYCenter.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            hStack.heightAnchor.constraint(equalToConstant: 60),
            hStackYCenter
        ])
    }
    
    
    
    func expand() {
        self.state = .expanded
        self.initialFrame = self.frame
        
        
        self.addSubview(scrollView)
        scrollView.addSubview(map)
        self.addSubview(topMenuStack)
        
        self.scrollViewHeightAnchor = scrollView.heightAnchor.constraint(equalToConstant: 0)
        self.scrollViewTopAnchor = scrollView.topAnchor.constraint(equalTo: hStack.bottomAnchor)
        
        self.topMenuStackHeightAnchor = topMenuStack.heightAnchor.constraint(equalToConstant: 0)
        self.topMenuStackTopAnchor = topMenuStack.topAnchor.constraint(equalTo: self.topAnchor)
        
        topMenuStack.addArrangedSubview(dateLabel)
        topMenuStack.addArrangedSubview(closeButton)
        
        hStackTopAnchor = hStack.topAnchor.constraint(equalTo: topMenuStack.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            map.centerXAnchor.constraint(equalTo: hStack.centerXAnchor),
            map.widthAnchor.constraint(equalTo: hStack.widthAnchor),
            map.heightAnchor.constraint(equalToConstant: 240),
            map.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: hStack.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: hStack.centerXAnchor),
            self.scrollViewTopAnchor!,
            self.scrollViewHeightAnchor!,
            
            topMenuStack.centerXAnchor.constraint(equalTo: hStack.centerXAnchor),
            topMenuStack.widthAnchor.constraint(equalTo: hStack.widthAnchor),
            self.topMenuStackTopAnchor!,
            self.topMenuStackHeightAnchor!,
            
            hStackTopAnchor!
        ])
        
        self.layoutIfNeeded()
        
        hStackTopAnchor!.constant          = 10
        scrollViewTopAnchor!.constant             = 10
        topMenuStackTopAnchor!.constant    = 10
        topMenuStackHeightAnchor!.constant = 30
        scrollViewHeightAnchor!.constant          = 240
        
        
        animator.addAnimations {
            self.frame.size.height = 400
            self.center = self.superview!.center
        }
        
        animator.addAnimations({
            self.map.alpha = 1.0
            self.topMenuStack.alpha = 1.0
        }, delayFactor: 0.1)
        
        animator.startAnimation()
    }
    
    @objc func collapse() {
        self.state = .collapsed
        
        animator.addAnimations {
            self.hStackTopAnchor!.constant          = 5
            self.scrollViewTopAnchor!.constant             = 0
            self.topMenuStackTopAnchor!.constant    = 0
            self.scrollViewHeightAnchor!.constant          = 0
            self.topMenuStackHeightAnchor!.constant = 0
            
            self.frame = self.initialFrame!
            self.topMenuStack.alpha = 0.0
            self.map.alpha = 0.0
            self.layoutIfNeeded()
        }
        animator.startAnimation()
        
        guard let record = self.record else { return }
        self.delegate?.reconfigureCell(record: record)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animator.duration - 0.05) {
            self.map.removeFromSuperview()
            self.topMenuStack.removeFromSuperview()
            self.removeFromSuperview()
            
        }
        
    }
    
    //    deinit {
    //        print("Deinit")
    //    }
    
    
}

extension RecordView {
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

extension RecordView: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var region = mapView.region
        region.center = view.annotation!.coordinate
        print("kjh")
        mapView.setRegion(region, animated: true)
    }
}

extension Record {
    
    func getLocation() -> CLLocationCoordinate2D {
        let split: [Double] = location!.split(separator: ",").map { Double($0)! }
        return CLLocationCoordinate2D(latitude: split[0], longitude: split[1])
    }
}

extension UIImage {
    /// Given a required height, returns a (rasterised) copy
    /// of the image, aspect-fitted to that height.
    
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
