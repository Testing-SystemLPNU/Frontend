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
        viewModel.showProgressView = false
        // do login
        viewModel.isLoggedIn = true
        publishUpdate()
    }
}

extension LoginHostModel: BackNavigation {
    func back() {
        viewModel.showSignup = false
        checkLogin()
        publishUpdate()
    }
}
