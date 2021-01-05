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
    var data: [Record] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        request.sortDescriptors = [.init(key: "date", ascending: true)]
        request.returnsObjectsAsFaults = false
        var records : [Record] = []
        do {
            let result = try context.fetch(request)
            records = (result as! [NSManagedObject]).map { $0 as! Record }
            
        } catch {
            
            print("Failed")
        }
        return records.reversed()
        
    }
    
    var dates: [String] {
        var uniqueDates: [String] = []
        for i in data.map({ $0.date }) {
            let d = i!.getDay()
            if !uniqueDates.contains(d) {
                uniqueDates.append(d)
            }
        }
        return uniqueDates
        
    }
    
    var records_2d: [[Record]] = []
    
    let addRecordSuccessFrame: CGRect   = CGRect(x: -2 * UIScreen.main.bounds.width,
                                                 y: UIScreen.main.bounds.height * 1/3,
                                                 width: UIScreen.main.bounds.width * 4,
                                                 height: UIScreen.main.bounds.height * 4)
    
    let addRecordDismissFrame: CGRect   = CGRect(x: 0,
                                                 y: 0,
                                                 width: UIScreen.main.bounds.width * 2,
                                                 height: UIScreen.main.bounds.height * 1/4)
    
    var record: Record? = nil
    let addRecordView = AddRecordView()
    var startingPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addRecordButton: UIButton!
    var indexPathOfSelectedRecord: IndexPath?
    let blurEffect = UIBlurEffect(style: .light)
    
    var recordViewHeightAnchor: NSLayoutConstraint?
    var recordViewYCenter: NSLayoutConstraint?
    var mapHeightAnchor: NSLayoutConstraint?
    var topMenuStackHeightAnchor: NSLayoutConstraint?
    var mapTopAnchor: NSLayoutConstraint?
    var topMenuStackTopAnchor: NSLayoutConstraint?
    
    var addRecordViewHeightAnchor: NSLayoutConstraint?
    var addRecordViewCenterYAnchor: NSLayoutConstraint?
    var addRecordViewCenterXAnchor: NSLayoutConstraint?
    
    var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        addRecordView.delegate = self
        
        print(data.count)
    
        for date in dates {
            let nested = data.filter { $0.date?.getDay() == date }
            records_2d.append(nested)
        }
        
        self.blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        blurView.layer.zPosition = 1
        
        table.layer.zPosition = 0
        
        addRecordViewHeightAnchor = addRecordView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6)
        addRecordViewCenterYAnchor = addRecordView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        addRecordViewCenterXAnchor = addRecordView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        addRecordButton.addTarget(self, action: #selector(addRecordButtonTapped), for: .touchUpInside)
        
        table.reloadData()
        
    }
    
    @objc func addRecordButtonTapped(_ sender: UIButton) {
        view.addSubview(addRecordView)
        addRecordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addRecordView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            addRecordViewHeightAnchor!,
            addRecordViewCenterYAnchor!,
            addRecordViewCenterXAnchor!
        ])
        
    }
    
    
}
