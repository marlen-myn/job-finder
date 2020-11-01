//
//  JobFinderApp.swift
//  JobFinder
//
//  Created by Marlen Mynzhassar on 10/28/20.
//

import SwiftUI

@main
struct Job_FinderApp: App {
    let persistenceController = PersistenceController.shared
    let jobSearch: JobSearch
    
    init() {
        jobSearch =  JobSearch(title: "Swift", type: "All", location: "All")
    }
    
    var body: some Scene {
        WindowGroup {
            JobFinderView(jobSearch: jobSearch)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
