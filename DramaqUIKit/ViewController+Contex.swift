//
//  ViewController+Contex.swift
//  DramaqUIKit
//
//  Created by Петрос Тепоян on 1/8/21.
//

import Foundation
import UIKit

extension ViewController : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let action = UIAction(title: "Edit", image: nil, identifier: .none) { action in
                self.table.setEditing(true, animated: true)
                self.isEditingRecordsTable.toggle()
            }
            return UIMenu(title: "Menu",
                          image: nil,
                          identifier: .edit,
                          options: .displayInline,
                          children: [action])
        }
        return configuration
    }
    
    
}
