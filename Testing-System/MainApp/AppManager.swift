//
//  AppManager.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

final class AppManager {
    static let shared = AppManager()
    let store = Store()
    let serialTasks = SerialTasks(name: "AppManager")
    
    private init() {}
}
