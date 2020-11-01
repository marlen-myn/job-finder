//
//  FilterJobs.swift
//  Job Finder
//
//  Created by Marlen Mynzhassar on 10/25/20.
//

import SwiftUI

struct FilterJobs: View {
    
    @ObservedObject var jobs = Jobs()
    @Binding var jobSearch: JobSearch
    @Binding var isPresented: Bool
    @State private var draft: JobSearch
    
    init(jobSearch: Binding<JobSearch>, isPresented: Binding<Bool>) {
        _jobSearch = jobSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: jobSearch.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $draft.type) {
                    ForEach(jobs.jobTypes, id: \.self) { (jobType: String?) in
                        Text(jobType ?? "All").tag(jobType)
                    }
                }
                Picker("Title", selection: $draft.title) {
                    ForEach(jobs.jobTitles, id: \.self) { (jobTitle: String?) in
                        Text(jobTitle ?? "All").tag(jobTitle)
                    }
                }
                Picker("Location", selection: $draft.location) {
                    ForEach(jobs.jobLocations, id: \.self) { (jobLocation: String?) in
                        Text(jobLocation ?? "All").tag(jobLocation)
                    }
                }
            }
            .navigationBarTitle("Filter Jobs", displayMode: .inline)
            .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            self.isPresented = false
        }
    }
    var done: some View {
        Button("Done") {
            self.jobSearch = self.draft
            self.isPresented = false
        }
    }
}
