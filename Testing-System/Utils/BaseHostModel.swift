//
//  BaseHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation
import Combine

class BaseHostModel: ObservableObject {
    
    weak var backAction: BackNavigation?
    
    convenience init(backAction: BackNavigation? = nil) {
        self.init()
        self.backAction = backAction
    }
    
    func goBack() {
        backAction?.back()
        publishUpdate()
    }
    
    func publishUpdate() {
        updateObjectInMainThread()
    }
    
    private func updateObjectInMainThread() {
        if Thread.isMainThread {
            objectWillChange.send()
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.updateObjectInMainThread()
        }
    }
}
