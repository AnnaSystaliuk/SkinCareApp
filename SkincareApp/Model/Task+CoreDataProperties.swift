//
//  Task+CoreDataProperties.swift
//  SkincareApp
//
//  Created by Anna on 10/21/21.
//
//

import Foundation
import CoreData
import UIKit

extension Task {

    @nonobjc public class func taskFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged private var time: Int16
    @NSManaged private var type: Int16
    @NSManaged private var day: Int16
    @NSManaged public var name: String
    
    
    var weekday: Weekday {
        return Weekday.init(rawValue: day)!
    }
    
    var product: ProductType {
        return ProductType.init(rawValue: type)!
    }

    var productTime: ProductTime {
        return ProductTime.init(rawValue: time)!
    }
}

extension Task : Identifiable {

}


extension Task {
    
    static var appContext: NSManagedObjectContext
    { (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }
    
    static func createTask(with day: Weekday, product: ProductType, time: ProductTime, name: String) -> Task {
        
        var task: Task!
        
        appContext.performAndWait {
            task = Task(context: appContext)
            task.day = day.rawValue
            task.time = time.rawValue
            task.type = product.rawValue
            task.name = name
            
            try! appContext.save()
        }
        
        return task
    }
    static func fetchData() -> [Task]{
        let fetchRequest = Task.taskFetchRequest()
        var tasks = [Task]()
        appContext.performAndWait {
            tasks = try! appContext.fetch(fetchRequest) as [Task]
        }
        return tasks
    }
}
