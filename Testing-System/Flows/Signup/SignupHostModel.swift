//
//  SignupHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class SignupHostModel: BaseHostModel {
    @Published var viewModel: SignupViewModel = SignupViewModel()
    
    private func doLoginAsync() async {
//        viewModel.showProgressView = false
//        // do login
//        viewModel.isLoggedIn = true
//        publishUpdate()
    }
}
