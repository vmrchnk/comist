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
    
    static let tag = "class: TaskEntity /"
    
    
    static func update(new updatedTask: TaskEntity, in context: NSManagedObjectContext){
        if let oldTask =  getFromDataStore(by: updatedTask.timestamp, with: context){
            oldTask.title = updatedTask.title
            oldTask.taskDescription = updatedTask.taskDescription
            oldTask.state   = updatedTask.state
            
            // saving
            do{
                _ = try context.save()
            } catch{
                print("\(tag) update -> error updating \(error.localizedDescription)")
            }
        }else {
            print("\(tag) update -> task == nil (create new task")
        }
    }
    
    
    static func getFromDataStore(by timestemp: Int64, with context: NSManagedObjectContext) -> TaskEntity? {
        let request: NSFetchRequest<TaskEntity> = fetchRequest()
        request.predicate = NSPredicate(format: "timestamp == %lld", timestemp)
        do{
            let task = try context.fetch(request).first
            return task
        }catch {
            print("\(tag) getFromDataStore ->  \(error)")
        }
        return nil
        
    }
    
    static func createTask(title: String, descrpiption: String, type: ComistType = .none, argumentEntity: Set<ArgumentEntity>? = nil, in context: NSManagedObjectContext) -> TaskEntity? {
        
        let taskEntity = TaskEntity(context: context)
        taskEntity.timestamp = Date().toMillis()
        taskEntity.title = title
        taskEntity.taskDescription = descrpiption
        taskEntity.state = Int16(type.rawValue)
        // task Arguments
        if let argSet = argumentEntity {
            taskEntity.addToArgument(argSet as NSSet)
        }
        do{
            _ = try context.save()
        }catch{
            print("TaskEntity.createTask ->  \(error)")
        }
        return taskEntity
    }
    
    
}
