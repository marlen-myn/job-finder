//
//  Jobs.swift
//  Job Finder
//
//  Created by Marlen Mynzhassar on 10/25/20.
//

import SwiftUI

class Jobs: ObservableObject, Identifiable {
    
    var jobTitles = ["Swift", "Python", "PHP"]
    var jobTypes = ["All","Full Time"]
    var jobLocations = ["All","Remote","San Jose", "Toronto", "Amsterdam"]
}
