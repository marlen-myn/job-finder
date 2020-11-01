//
//  JobItem.swift
//  JobFinder
//
//  Created by Marlen Mynzhassar on 10/28/20.
//

import CoreData

extension Job {
    
    static func withId(_ id: String, in context: NSManagedObjectContext) -> Job {
        let request = fetchRequest(NSPredicate(format: "id = %@", id))
        let jobs = (try? context.fetch(request)) ?? []
        if let job = jobs.first {
            return job
        } else {
            return Job(context: context)
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Job> {
        let request = NSFetchRequest<Job>(entityName: "Job")
        request.sortDescriptors = [NSSortDescriptor(key: "title_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    var title: String {
        get { title_! }
        set { title_ = newValue }
    }
    
    var created_at: String {
        get { created_at_! }
        set { created_at_ = newValue }
    }
}
