//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

@objc class SelectionManager: NSObject {
    var parentController: UIViewController
    var alert: UIAlertController!
    var button: UIBarButtonItem!
    
    init(title: String, options: [String], parentController: UIViewController, selected: (@escaping (Int, String) -> Void)) {
        self.parentController = parentController
        
        super.init()
        
        alert = UIAlertController(options: options) {  (index: Int, selection: String) in
            self.button.title = selection
            selected(index, selection)
        }
        
        button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(buttonPressed))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed() {
        parentController.navigationController?.present(alert, animated: true, completion: nil)
    }
}
