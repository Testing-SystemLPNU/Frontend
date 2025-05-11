//
//  InitHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class LoginHostModel: BaseHostModel {
    @Published var viewModel: LoginViewModel
    
    override init() {
        self.viewModel = LoginViewModel()
    }
    
    func login() {
        viewModel.showProgressView = true
        publishUpdate()
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doLoginAsync()
        }
    }
    
    func showSignUp() {
        viewModel.showSignup = true
        publishUpdate()
    }
    
    func checkLogin() {
        viewModel.isLoggedIn = AppManager.shared.store.token != nil
        publishUpdate()
    }
    
    private func doLoginAsync() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        let loginRequest = LoginRequest(email: viewModel.username,
                                          password: viewModel.password)
        do {
            let result = try await AppManager.shared.apiConnector.login(loginRequest)
            AppManager.shared.store.token = result.token
            checkLogin()
        } catch {
            print("Loggin error: \(error)")
        }
    }
}

extension LoginHostModel: BackNavigation {
    func back() {
        viewModel.showSignup = false
        checkLogin()
        publishUpdate()
    }
}
