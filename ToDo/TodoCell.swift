//
//  TodoCell.swift
//  ToDo
//
//  Created by Hugo Medina on 28/06/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import Foundation
import UIKit

class TodoCell : UITableViewCell {
    var todo: Todo? = nil
    var index: Int? = nil
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var toggleButn: UIButton!
    
    @IBAction func toggle(_ sender: UIButton) {
        if nil != todo,
           let index = index,
           let viewController = parentViewController as? ViewController {
            switch todo!.state {
            case .done:
                todo!.state = .todo
                viewController.allTodos[index].state = .todo
            case .todo:
                todo!.state = .done
                viewController.allTodos[index].state = .done
            }
        }
        setup()
    }
    
    func setup() {
        if let todo = todo {
            content.text = todo.content
            switch todo.state {
            case .done:
                toggleButn.setTitleColor(UIColor.green, for: UIControl.State.normal)
            case .todo:
                toggleButn.setTitleColor(UIColor.red, for: UIControl.State.normal)
            }
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
