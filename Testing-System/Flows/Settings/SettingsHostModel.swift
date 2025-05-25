//
//  SettingsHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class SettingsHostModel: BaseHostModel {
    @Published var viewModel: SettingsViewModel
    
    init(backAction: BackNavigation) {
        self.viewModel = SettingsViewModel()
        super.init(backAction: backAction)
    }
    
    func changePassword() {
        viewModel.changePasswordMode = true
        viewModel.changePassoword = ChangePassword(oldPassword: "", newPassword: "", confirmNewPassword: "")
        publishUpdate()
    }
    
    func performChangePassword() {
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doChangePassword()
        }
    }
    
    func logout() {
        goBack()
        AppManager.shared.store.token = nil
    }
    
    func closeChangePasswordMode() {
        viewModel.changePasswordMode = false
        publishUpdate()
    }
    
    func loadUserData() {
        AppManager.shared.serialTasks.run { [weak self] in
            await self?.doLoadUserData()
        }
    }
    
    private func doLoadUserData() async {
        defer {
            viewModel.showProgressView = false
            publishUpdate()
        }
        
        do {
            viewModel.userInfo = try await AppManager.shared.apiConnector.getUserInfo()
        } catch {
            print("Change password error: \(error)")
        }
    }
    
    private func doChangePassword() async {
        defer {
            back()
        }
        
        do {
            try await AppManager.shared.apiConnector.updatePassword(body: viewModel.changePassoword)
        } catch {
            print("Change password error: \(error)")
        }
    }
}

extension SettingsHostModel: BackNavigation {
    func back() {
        defer {
            publishUpdate()
        }
        viewModel.changePasswordMode = false
    }
}

