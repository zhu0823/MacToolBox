//
//  VisionAgent.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import Foundation
import AppKit
import Vision

class ImageAgent {
    
    static let shared = ImageAgent()
    
    var languages: [String] = ["zh-Hans"]
    
    
    func loadImage(_ image: NSImage?, completion: @escaping (_ text: String?) -> Void) {
        guard let image = image?.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(nil)
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("request Error", error)
                completion(nil)
            } else {
                if let result = self.handleDetectionResults(results: request.results) {
                    completion(result)
                } else {
                    completion(nil)
                }
            }
        }
        
        request.recognitionLanguages = languages
        request.recognitionLevel = .accurate
        
        performDetection(request: request, image: image)
    }
    
    func performDetection(request: VNRecognizeTextRequest, image: CGImage) {
        request.cancel()
        
        let requests = [request]
        let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform(requests)
            } catch {
                print("performDetection Error:", error)
            }
        }
    }
    
    func handleDetectionResults(results: [Any]?) -> String? {
        
        guard let results = results, results.count > 0 else { return nil }
        
        var output: String = ""
        
        for result in results {
            if let observation = result as? VNRecognizedTextObservation {
                for text in observation.topCandidates(1) {
                    if !output.isEmpty {
                        output.append("\n")
                    }
                    output.append(text.string)
                }
            }
        }
        return output
    }
    
    
    /// 所有支持语言
    /// - Returns: 语言合集
    func showSupportsLanguages() -> [String] {
        do {
            let revision = VNRecognizeTextRequest.supportedRevisions.last
            let supportsLanguages = try VNRecognizeTextRequest.supportedRecognitionLanguages(for: .accurate, revision: revision ?? 2)
            return supportsLanguages
        } catch  {
            print("showSupportsLanguages Error:", error)
        }
        return ["en-US"]
    }
}
