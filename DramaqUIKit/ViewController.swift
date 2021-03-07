//
//  ViewController.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 12/23/20.
//

import UIKit
import CoreData
//import SwiftUI


class ViewController: UIViewController {
    lazy var context: NSManagedObjectContext = {
        let result = AppDelegate()
        return result.persistentContainer.viewContext
    }()
    
//    var model: RecordsModel { RecordsModel(context: context) }
    var model: RecordsModel!
    
    let addRecordSuccessFrame: CGRect   = CGRect(x: -2 * UIScreen.main.bounds.width,
                                                 y: UIScreen.main.bounds.height * 1/3,
                                                 width: UIScreen.main.bounds.width * 4,
                                                 height: UIScreen.main.bounds.height * 4)
    
    let addRecordDismissFrame: CGRect   = CGRect(x: -2 * UIScreen.main.bounds.width,
                                                 y: -UIScreen.main.bounds.height * 1/4,
                                                 width: UIScreen.main.bounds.width * 2,
                                                 height: UIScreen.main.bounds.height * 1/2)
    
    var record: Record? = nil
    var addRecordView: AddRecordView?
    var startingPoint: CGPoint = CGPoint(x: 0, y: 0)
    var isEditingRecordsTable: Bool = false
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addRecordButton: UIButton!
    var indexPathOfSelectedRecord: IndexPath?
    let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    
    var recordViewHeightAnchor: NSLayoutConstraint?
    var recordViewYCenter: NSLayoutConstraint?
    var mapHeightAnchor: NSLayoutConstraint?
    var topMenuStackHeightAnchor: NSLayoutConstraint?
    var mapTopAnchor: NSLayoutConstraint?
    var topMenuStackTopAnchor: NSLayoutConstraint?
    
    var addRecordViewHeightAnchor: NSLayoutConstraint?
    var addRecordViewCenterYAnchor: NSLayoutConstraint?
    var addRecordViewCenterXAnchor: NSLayoutConstraint?
    var addRecordViewCenter: CGPoint?
    
    var blurView: UIVisualEffectView!
    
    weak var recordViewScrollingDelegate: RecordViewScrollingDelegate?
    
    weak var cellToReconfigure: RecordViewTableCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        model = RecordsModel(context: context)
//        table.allowsMultipleSelection = true
//        table.allowsMultipleSelectionDuringEditing = true
        
        self.blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        blurView.layer.zPosition = 1
        view.addSubview(blurView)
        blurView.alpha = 0.0
        
        table.layer.zPosition = 0
        addRecordButton.addTarget(self, action: #selector(addRecordButtonTapped(_:)), for: .touchUpInside)
        
        table.reloadData()
        
    }
    
    func toggleBlurView() {
        blurView.alpha = blurView.alpha == 0.0 ? 1.0 : 0.0
    }
    
    @objc func addRecordButtonTapped(_ sender: UIButton) {
        self.addRecordView = AddRecordView()
        self.addRecordView?.delegate = self
        
        self.addRecordView!.alpha = 0.0
        view.addSubview(self.addRecordView!)
        self.addRecordView!.frame.size.width = view.frame.width * 0.9
        self.addRecordView!.frame.size.height = view.frame.height * 0.6
        addRecordViewCenter = view.center
        self.addRecordView!.center = addRecordViewCenter!
        self.addRecordView?.layer.zPosition = 3
        let animator = AnimationPatterns.addRecordView
        
        animator.addAnimations {
            self.addRecordView!.alpha = 1.0
            self.toggleBlurView()
        }
        
        animator.startAnimation()
        
    }
    
    
}
