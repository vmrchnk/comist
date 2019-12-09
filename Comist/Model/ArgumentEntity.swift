//
//  ArgumentEntity.swift
//  Comist
//
//  Created by dewill on 10.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit
import CoreData

class ArgumentEntity: NSManagedObject {
    
    static func createArgEntity(type: ComistType, text:String, value: Int, in context: NSManagedObjectContext) -> ArgumentEntity {
        
        let arg = ArgumentEntity(context: context)
        arg.timestamp = Date().toMillis()
        arg.text = text
        arg.type =  Int16(type.rawValue)
        arg.value = Int64(value)
        
        return arg
    }
//    
//    
//    static func includeIntoTaskEntity(array: [ArgumentModel], in context: NSManagedObjectContext) -> Set<ArgumentEntity> {
//        var argsSet = Set<ArgumentEntity>()
//        for argsModel in array {
//            argsSet.insert(createArgEntity(from: argsModel, in: context) )
//        }
//        return argsSet
//    }
    
    
    
}
