//
//  JobFinderView.swift
//  Job Finder
//
//  Created by Marlen Mynzhassar on 10/24/20.
//

import SwiftUI
import WebKit
import CoreData

// representing a filter struct
struct JobSearch {
    var title: String?
    var type: String?
    var location: String?
}

extension JobSearch {
    var predicate: NSPredicate {
        var format = ""
        var args: [String] = []
        if title != nil, title != "All" {
            format += "searchTitle CONTAINS[cd] %@"
            args.append(title!)
        } else {
            format += "id > %@"
            args.append("0")
        }
        if type != nil, type != "All" {
            format += " and type = %@"
            args.append(type!)
        }
        if location != nil, location != "All" {
            format += " and location = %@"
            args.append(location!)
        }
        print(format)
        print(args)
        return NSPredicate(format: format, argumentArray:args)
    }
}

struct JobFinderView: View {
    @Environment(\.managedObjectContext) var context
    @State var jobSearch: JobSearch
    
    var body: some View {
        NavigationView {
            JobList(jobSearch, in: context)
                .navigationBarItems(trailing: filter)
        }
    }
    
    @State private var showFilter = false
    
    var filter: some View {
        Button("Filter") {
            self.showFilter = true
        }
        .sheet(isPresented: $showFilter) {
            FilterJobs(jobSearch: self.$jobSearch, isPresented: self.$showFilter)
        }
    }
}

struct JobList: View {
    @FetchRequest var jobs: FetchedResults<Job>
    @ObservedObject var jobFetcher: JobFetcher
    @Environment(\.managedObjectContext) var context
    
    init(_ jobSearch: JobSearch, in context: NSManagedObjectContext) {
        jobFetcher = JobFetcher(jobSearch: jobSearch, in: context)
        let request = Job.fetchRequest(jobSearch.predicate)
        _jobs = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        List {
            ForEach(jobs, id: \.id) { job in
                NavigationLink(destination: JobItemFull(job: job)
                                .navigationBarTitle(job.title)
                ) {
                    JobItem(job: job)
                }
            }
        }.navigationBarTitle("Jobs (\(jobs.count))", displayMode: .inline)
    }
}

struct JobItem: View {
    let job: Job
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(job.title)
            Text("\(job.company_name_ ?? "" ), \(job.location ?? "")").font(.caption)
            Text(job.created_at).font(.caption)
        }
        .lineLimit(1)
    }
}

struct JobItemFull: View {
    let job: Job
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack (alignment: .leading) {
                    Link(job.title, destination: URL(string: job.url ?? "")!)
                    Text("\(job.company_name_ ?? ""), \(job.location ?? "")").font(.caption)
                    Text(job.created_at).font(.caption)
                    Text(job.type ?? "").font(.caption)
                }
                Spacer()
                CompanyLogo(job.company_logo)
            }
            Divider()
            HTMLStringView(htmlContent: job.job_description ?? "")
        }.padding()
    }
}

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        uiView.loadHTMLString(headerString + htmlContent, baseURL: nil)
    }
}
