//
//  CoursesHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class CoursesHostModel: BaseHostModel {
    @Published var viewModel: SignupViewModel = SignupViewModel()
    
    
    func addNewCourse() {
        
    }
    
    func showSettings() {
        AppManager.shared.store.token = nil
        goBack()
    }
}
