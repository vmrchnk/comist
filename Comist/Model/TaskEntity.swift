//
//  TaskEntity.swift
//  Comist
//
//  Created by dewill on 10.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit
import CoreData

class TaskEntity: NSManagedObject {
    
    
    static func findOrCreateTask(matching taskModel: TaskModel, in context: NSManagedObjectContext) throws -> TaskEntity{
        
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "timesTemp == %@", taskModel.timestemp)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                // assert 'sanity': if condition false ... then print message and interrupt program
                assert(matches.count == 1, "TaskEntity.findOrCreateTask -- database inconsistency")
                return matches[0]
                
            }
        }catch {
            throw error
        }
        // no match, instantiate TaskEntity
        
        let task = TaskEntity(context: context)
        //        task.addToArgument(taskModel.positiveArgs as N)
        //        task.addToArgument(taskModel.negativeArgs)
        return task
        
    }
    
    
    static func createTask(model: TaskModel, in context: NSManagedObjectContext) {
        
        let taskEntity = TaskEntity(context: context)
        taskEntity.timestamp = Int64(model.timestemp)
        taskEntity.title = model.title
        taskEntity.taskDescription = model.description
        taskEntity.state = Int16(model.state.rawValue)
        // task Arguments
        var args = [ArgumentModel]()
        args.append(contentsOf: model.negativeArgs)
        args.append(contentsOf: model.positiveArgs)
        let argsEntitySet = ArgumentEntity.includeIntoTaskEntity(array: args, in: context)
        taskEntity.addToArgument(argsEntitySet as NSSet)
        
        
        do{
            _ = try context.save()
        }catch{
            print("TaskEntity.createTask ->  \(error)")
        }
    }
    
}
