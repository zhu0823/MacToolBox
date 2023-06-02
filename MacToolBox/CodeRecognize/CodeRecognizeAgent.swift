//
//  CodeRecognizeAgent.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import Foundation
import AppKit
import CoreImage.CIFilterBuiltins

class CodeRecognizeAgent {
    
    /// 单类
    static let shared = CodeRecognizeAgent()
    
    /// 从剪切版获取图片
    /// - Returns: 图片
    func getQRCodeImageFromClipboard() -> NSImage? {
        let pasteboard = NSPasteboard.general
        if let fileUrl = pasteboard.string(forType: .fileURL),
           let url = URL(string: fileUrl) {
            if let image = NSImage(contentsOf: url) {
                return image
            }
        }
        if let image = NSImage(pasteboard: pasteboard) {
            return image
        }
        return nil
    }
    
    
    /// 解析二维码
    /// - Parameter qrCodeImage: 图片
    /// - Returns: 文本
    func decodeQRCode(_ qrCodeImage: NSImage) -> String? {
        let context = CIContext()
        let ciImage = CIImage(data: qrCodeImage.tiffRepresentation!)!
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let features = detector.features(in: ciImage)
        
        for feature in features {
            if let qrCodeFeature = feature as? CIQRCodeFeature {
                return qrCodeFeature.messageString
            }
        }
        return nil
    }
}
