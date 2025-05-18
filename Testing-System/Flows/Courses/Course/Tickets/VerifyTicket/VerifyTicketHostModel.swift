//
//  VerifyTicketHostModel.swift
//  Testing-System
//
//  Created by Ihor Shevchuk on 5/10/25.
//

import Foundation
import UIKit
import Vision

class VerifyTicketHostModel: BaseHostModel {
    @Published var viewModel: VerifyTicketViewModel
    
    init(course: Course, ticket: Ticket, backAction: BackNavigation) {
        self.viewModel = VerifyTicketViewModel(course:course, ticket: ticket)
        super.init(backAction: backAction)
    }
    
    
    func process(image: UIImage) {
        toggleCamera()
        viewModel.showProgressView = true
        publishUpdate()
        
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!)
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }
            
            defer {
                self.viewModel.showProgressView = false
                self.publishUpdate()
            }
            
            if let error {
                print("Error: \(error)")
                return
            }
            
            guard let observations =
                    request.results as? [VNRecognizedTextObservation] else {
                return
            }
            let recognizedStrings = observations.compactMap { observation in
                // Return the string of the top VNRecognizedText instance.
                print("Detected: \(observation.boundingBox)")
                return observation.topCandidates(1).first?.string
            }
            
            print(recognizedStrings)
        }
        request.recognitionLanguages = ["en"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func toggleCamera() {
        viewModel.showCameraView.toggle()
        publishUpdate()
    }
}
