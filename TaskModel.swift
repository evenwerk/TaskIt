//
//  TaskModel.swift
//  TaskIt
//
//  Created by Tim Even on 19-03-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
