//
//  ViewController.swift
//  DragDropTranslate
//
//  Created by Thiago Santiago on 8/14/18.
//  Copyright © 2018 Thiago Santiago. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var translateData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textDragDelegate = self
        tableView.dropDelegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITextDragDelegate, UITableViewDropDelegate {
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, dragPreviewForLiftingItem item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let imageView = UIImageView(image: UIImage(named: "drag"))
        imageView.backgroundColor = .clear
        
        let dragView = textDraggableView
        let dragPoint = session.location(in: dragView)
        let target = UIDragPreviewTarget(container: dragView, center: dragPoint)
        
        return UITargetedDragPreview(view: imageView, parameters: UIDragPreviewParameters(), target: target)
    }
    
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, itemsForDrag dragRequest: UITextDragRequest) -> [UIDragItem] {
    
        guard let textSelected = textView.text(in: dragRequest.dragRange) else { return [] }
        print("\(textSelected)")
        let itemProvider = NSItemProvider(object: textSelected as NSString)
        let itemDragged = UIDragItem(itemProvider: itemProvider)
        return [itemDragged]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let stringArray = items as? [String] else { return }
            
            self.translateData.insert(stringArray.first!, at: destinationIndexPath.row)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslateTableViewCell", for: indexPath) as! TranslateTableViewCell
        
        let textDragged = translateData[indexPath.row]
        cell.textToTranslate.text = textDragged
        
        return cell
    }
}

