//
//  ArgumentModel.swift
//  Comist
//
//  Created by dewill on 09.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import Foundation

struct ArgumentModel {
    let text: String
    let value: ArgumentValue
    let type: ArgumentType
}

enum ArgumentType: Int {
    case possitive
    case negative
}

enum ArgumentValue: Int {
    case low = 1
    case medium = 3
    case hight = 5
    case highest = 8
}
