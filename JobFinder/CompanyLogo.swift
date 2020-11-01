//
//  CompanyLogo.swift
//  Job Finder
//
//  Created by Marlen Mynzhassar on 10/25/20.
//

import SwiftUI

struct CompanyLogo: View {
    
    private var image: UIImage?
    
    init(_ company_logo: String?) {
        if let url = company_logo {
            let data = try? Data(contentsOf: URL(string: url)!)
            if let image = data {
                self.image = UIImage(data: image)
            }
        }
    }
    
    var body: some View {
        Group {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .trailing)
                
            } else {
                EmptyView()
            }
        }
    }
}
