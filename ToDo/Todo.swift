//
//  Todo.swift
//  ToDo
//
//  Created by Hugo Medina on 28/06/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

import Foundation

struct Todo : Codable {
    let id: Int?
    var content: String?
    var state: State
}

enum State: String, Codable {
    case todo
    case done
}
