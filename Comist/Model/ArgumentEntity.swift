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
    
    static func createArgEntity(from model: ArgumentModel, in context: NSManagedObjectContext) -> ArgumentEntity {
        
        let arg = ArgumentEntity(context: context)
        arg.timestamp = Int64(model.timestamp)
        arg.text = model.text
        arg.type =  Int16(model.type.rawValue)
        arg.value = Int64(model.value.rawValue)
        
        return arg
    }
    
    
    static func includeIntoTaskEntity(array: [ArgumentModel], in context: NSManagedObjectContext) -> Set<ArgumentEntity> {
        var argsSet = Set<ArgumentEntity>()
        for argsModel in array {
            argsSet.insert(createArgEntity(from: argsModel, in: context) )
        }
        return argsSet
    }
    
    
    
}
