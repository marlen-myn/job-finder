//
//  Job.swift
//  Job Finder
//
//  Created by Marlen Mynzhassar on 10/24/20.
//

import Foundation

struct JobFetched: Codable, Identifiable {
    
    var company: String
    var id: String
    var title: String
    var created_at: String
    var company_logo: String?
    var company_url: String?
    var description: String?
    var how_to_apply: String?
    var location: String?
    var type: String?
    var url: String?
}
