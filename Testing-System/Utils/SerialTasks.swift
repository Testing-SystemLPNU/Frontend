//
//  SerialTasks.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation

class SerialTasks {

    private let operationQueue: OperationQueue

    init(name: String = "") {
        operationQueue = OperationQueue()
        operationQueue.name = name
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
    }

    func run(block: @escaping () async throws -> Void) {
        operationQueue.addOperation {
            let semaphore = DispatchSemaphore(value: 0)
            Task {
                defer {
                    semaphore.signal()
                }
                try await block()
            }
            semaphore.wait()
        }
    }
}
