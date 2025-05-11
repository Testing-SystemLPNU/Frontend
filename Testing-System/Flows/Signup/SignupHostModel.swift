//
//  SignupHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class SignupHostModel: BaseHostModel {
    @Published var viewModel: SignupViewModel = SignupViewModel()
    
    
    func signup() {
        viewModel.showProgressView = true
        publishUpdate()
        
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doSignup()
        }
    }
    
    private func doSignup() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        
        let signupRequest = SignupRequest(email: viewModel.email,
                                          password: viewModel.password,
                                          confirmPassword: viewModel.confirmPassword,
                                          fullName: viewModel.fullname)
        do {
            let result = try await AppManager.shared.apiConnector.signup(signupRequest)
            AppManager.shared.store.token = result.token
            goBack()
        } catch {
            print("Signup error: \(error)")
        }
    }
}
