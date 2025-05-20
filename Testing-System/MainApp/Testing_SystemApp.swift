//
//  Testing_SystemApp.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI

@main
struct Testing_SystemApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            InitView(hostModel: InitHostModel())
                .padding(.top, 15)
        }
    }
}
