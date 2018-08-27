//
//  ViewController.swift
//  DragDropTranslate
//
//  Created by Thiago Santiago on 8/14/18.
//  Copyright © 2018 Thiago Santiago. All rights reserved.
//

import UIKit

protocol DragDropTranslateViewControllerDelegate {
    func showTextTranslated(_ text: String)
    func showErrorMessage(_ error: String)
}

class DragDropTranslateViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var toTranslateData = [String]()
    var translatedData = [String]()
    
    var interactor: TranslateInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialConfig()
    }
    
    func setInitialConfig() {
        textView.textDragDelegate = self
        tableView.dropDelegate = self
        tableView.dataSource = self
        
        let interactor = TranslateInteractor()
        self.interactor = interactor
        let presenter = TranslatePresenter()
        presenter.viewController = self
        interactor.presenter = presenter
    }
}

extension DragDropTranslateViewController: UITextDragDelegate, UITableViewDropDelegate {
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
            
            self.toTranslateData.insert(stringArray.first!, at: destinationIndexPath.row)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            
            self.interactor?.translate(text: stringArray.first!)
        }
    }
}

extension DragDropTranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toTranslateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslateTableViewCell", for: indexPath) as! TranslateTableViewCell
        
        let textDragged = toTranslateData[indexPath.row]
        var textTranslated = ""
        
        if toTranslateData.count == translatedData.count {
            textTranslated = translatedData[indexPath.row]
        }
       
        
        cell.textToTranslate.text = textDragged
        cell.textTranslated.text = textTranslated
        
        return cell
    }
}

extension DragDropTranslateViewController: DragDropTranslateViewControllerDelegate {
    func showTextTranslated(_ text: String) {
        translatedData.append(text)
    }
    
    func showErrorMessage(_ error: String) {
        print("Error!!!")
    }
}

