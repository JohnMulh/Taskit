//
//  TaskModel.swift
//  Taskit
//
//  Created by John Mulholland on 16/01/2015.
//  Copyright (c) 2015 John Mulholland. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)

class TaskModel: NSManagedObject {

    @NSManaged var task: String
    @NSManaged var subtask: String
    @NSManaged var date: NSDate
    @NSManaged var completed: NSNumber

}
