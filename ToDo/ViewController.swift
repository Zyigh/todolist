//
//  ViewController.swift
//  ToDo
//
//  Created by Hugo Medina on 28/06/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let ud = UserDefaults.standard
    private let udKey = "todos"
    private var storedTodos = [Todo]()
    var allTodos : [Todo] {
        get {
            return storedTodos
        }
        set {
            if let json = try? JSONEncoder().encode(newValue) {
                storedTodos = newValue
                ud.set(json, forKey: udKey)
            } else {
                ud.removeObject(forKey: udKey)
            }
        }
    }
    var displayableTodos = [Todo]()
    var onesToDisplay = VisibleTodos.all
    
    @IBOutlet weak var todos: UITableView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet var listModifierButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let t = ud.object(forKey: udKey) as? Data,
            let todos = try? JSONDecoder().decode([Todo].self, from: t) {
            storedTodos = todos
        }
        for btn in listModifierButtons {
            btn.cornerRadius = 5
            btn.borderColor = UIColor.black
            btn.borderWidth = 0.4
        }
        todos.dataSource = self
        setupTodos()
    }
    
    @IBAction func changeDisplayables(_ sender: UIButton) {
        if let t = sender.titleLabel?.text,
           let state = VisibleTodos(rawValue: t.lowercased()),
           state != onesToDisplay {
            onesToDisplay = state
            setupTodos()
        }
    }

    func setupTodos() {
        switch onesToDisplay {
        case .all:
            displayableTodos = allTodos
        case .doing:
            displayableTodos = allTodos.filter { $0.state == .todo }
        case .done:
            displayableTodos = allTodos.filter { $0.state == .done }
        }
        todos.reloadData()
    }

    @IBAction func send(_ sender: Any) {
        if let text = input.text,
            text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            allTodos.append(Todo(id: allTodos.last?.id ?? 0, content: text, state: .todo))
            input.text = nil
            setupTodos()
        }
    }
    
    enum VisibleTodos: String {
        case all, doing, done
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayableTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "todo") as? TodoCell {
            cell.todo = displayableTodos[indexPath.row]
            cell.index = indexPath.row
            cell.setup()
            
            return cell
        }
        return UITableViewCell()
    }
}

extension UIButton {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
