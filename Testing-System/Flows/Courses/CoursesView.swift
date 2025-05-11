//
//  CoursesView.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI
import NiceComponents

struct CoursesView: View {
    
    @StateObject var hostModel: CoursesHostModel
    
    @ViewBuilder
    func coursesView() -> some View {
        ZStack {
            NavigationView {
                Text("Hello, World!")
            }
            .navigationTitle("Available Courses")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "plus"))) {
                        hostModel.addNewCourse()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NiceButton("", style: .borderless, rightImage: NiceButtonImage(NiceImage(systemIcon: "gearshape.fill"))) {
                        hostModel.showSettings()
                    }
                }
            }
            
            if hostModel.viewModel.showProgressView {
                ProgressView()
            }
        }
    }
    
    var body: some View {
        VStack {
            coursesView()
        }
    }
}

#Preview {
    CoursesView(hostModel: CoursesHostModel())
        .padding()
}
