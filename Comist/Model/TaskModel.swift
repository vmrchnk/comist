//
//  TaskModel.swift
//  Comist
//
//  Created by dewill on 09.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import Foundation

struct TaskModel {
    let title, description: String
    let timestemp: Int64
    let state: ArgumentType
    let positiveArgs, negativeArgs: [ArgumentModel]
    
    
    init(title: String, description: String = "", positiveArgs: [ArgumentModel], negativeArgs: [ArgumentModel], state: ArgumentType = .none) {
        self.title = title
        self.description = description
        self.timestemp = Date().toMillis()
        self.positiveArgs = positiveArgs
        self.negativeArgs = negativeArgs
        self.state = state
    }
    
}
