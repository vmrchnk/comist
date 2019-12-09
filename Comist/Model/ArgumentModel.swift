//
//  ArgumentModel.swift
//  Comist
//
//  Created by dewill on 09.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import Foundation

//struct ArgumentModel: Hashable {
//    let timestamp: Int64
//    let text: String
//    let value: ArgumentValue
//    let type: ArgumentType
//
//
//    init(text: String, value: ArgumentValue, type: ArgumentType){
//        self.timestamp = Date().toMillis()
//        self.text = text
//        self.value = value
//        self.type = type
//    }
//}

//using for task ang args
enum ComistType: Int {
    case none = 0, positive, negative
    
    func getTitle() -> String {
        switch self {
        case .negative: return NSLocalizedString("negative", comment: "")
        case .positive: return NSLocalizedString("positive",  comment: "")
        case .none: return NSLocalizedString("not specified",  comment: "")
        }
    }
}

enum ArgumentValue: Int {
    case low = 1
    case medium = 3
    case hight = 5
    case highest = 8
}
