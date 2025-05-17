//
//  Testing_SystemApp.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/4/25.
//

import SwiftUI

@main
struct Testing_SystemApp: App {
    var body: some Scene {
        WindowGroup {
            InitView(hostModel: InitHostModel())
                .padding(.top, 15)
        }
    }
}
