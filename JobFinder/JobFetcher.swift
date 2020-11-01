//
//  JobFetcher.swift
//  Job Finder
//
//  Created by Marlen Mynzhassar on 10/24/20.
//

import SwiftUI
import Combine
import CoreData

class JobFetcher: ObservableObject {
    
    var endpoint = "https://jobs.github.com/positions.json"
    var context: NSManagedObjectContext
    
    var url: URL {
        URL(string: self.endpoint)!
    }
    
    var jobSearch: JobSearch {
        didSet {
            fetchJobsFromGitHub()
        }
    }
    
    init(jobSearch: JobSearch, in context: NSManagedObjectContext) {
        self.jobSearch = jobSearch
        self.context = context
        
        if let title = self.jobSearch.title {
            self.endpoint.append("?description=\(title.replacingOccurrences(of: " ", with: "+"))")
        }
        if let location = self.jobSearch.location {
            self.endpoint.append("&location=\(location.replacingOccurrences(of: " ", with: "+"))")
        }
        if self.jobSearch.type == "Full Time" {
            self.endpoint.append("&full_time=true")
        }
        print(self.endpoint)
        fetchJobsFromGitHub()
    }
    
    @Published var fetchedJobFromGitHub = [JobFetched]()
    @Published var fetchedJobs = [Job]()
    
    private var fetchJobCancellable: AnyCancellable?
    
    public func fetchJobsFromGitHub() {
        print("fetchData from GitHub called")
        fetchedJobFromGitHub = [JobFetched]()
        fetchJobCancellable?.cancel()
//        self.fetchJobCancellable = URLSession.shared.dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: [JobFetched].self, decoder: JSONDecoder())
//            .replaceError(with: [])
//            .eraseToAnyPublisher()
//            .receive(on: RunLoop.main)
//            .assign(to: \.fetchedJobFromGitHub, on: self)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.fetchedJobFromGitHub = try! JSONDecoder().decode([JobFetched].self, from: data)
                self.updateJobDatabase(from: self.fetchedJobFromGitHub)
            }
        }
        
        task.resume()
    }
    
    public func updateJobDatabase(from fetchedJobs: [JobFetched]) {
        print("Trying to save \(fetchedJobs.count)")
        for job in fetchedJobs {
            let newJob = Job.withId(job.id, in: context)
            newJob.title = job.title
            newJob.company_name_ = job.company
            newJob.company_logo = job.company_logo
            newJob.company_url = job.company_url
            newJob.created_at_ = job.created_at
            newJob.how_to_apply = job.how_to_apply
            newJob.id = job.id
            newJob.job_description = job.description
            newJob.location = job.location
            newJob.url = job.url
            newJob.searchTitle = jobSearch.title ?? job.title
            newJob.objectWillChange.send()
            try? context.save()
        }
    }
}
