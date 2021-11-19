//
//  Appointment+CoreDataProperties.swift
//  SkincareApp
//
//  Created by Anna on 10/22/21.
//
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func appointmentFetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var placeTitle: String?
    @NSManaged public var time: Date?
    @NSManaged public var procedureName: String?

}

extension Appointment : Identifiable {

}

extension Appointment {
    
    static var appContext: NSManagedObjectContext
    { (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }
    
    static func createAppointment(with placeTitle: String, time: Date?, procedureName: String) -> Appointment {
        
        var appt: Appointment!
        
        appContext.performAndWait {
            appt = Appointment(context: appContext)
            appt.placeTitle = placeTitle
            appt.time = time
            appt.procedureName = procedureName
            
            try! appContext.save()
        }
        
        return appt
    }
    static func fetchData() -> [Appointment]{
        let fetchRequest = Task.appointmentFetchRequest()
        var appts = [Appointment]()
        appContext.performAndWait {
            appts = try! appContext.fetch(fetchRequest) as [Appointment]
        }
        return appts
    }
}
