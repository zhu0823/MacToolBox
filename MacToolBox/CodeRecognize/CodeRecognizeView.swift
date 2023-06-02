//
//  CodeRecognizeView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import SwiftUI

struct CodeRecognizeView: View {
    @State private var qrCodeText: String = "There is no content"
    @State var image: NSImage?
    @State var isSuccess: Bool = false

    var body: some View {
        HStack {
            ZStack {
                DashedBorderView(isSuccess: $isSuccess)
                DropImageView(image: $image) { image in
                    transformText(image)
                }
            }
            .padding()

            VStack {
                
                TextEditor(text: $qrCodeText)
                    .font(.system(size: 16))

                HStack {
                    Button("导入") {
                        getQRCode()
                    }
                    Button("复制") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(self.qrCodeText, forType: .string)
                    }
                }
            }
            .padding([.trailing, .top, .bottom])
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.modifierFlags.contains(.command) && event.keyCode == 9 {
                    getQRCode()
                    return nil
                }
                return event
            }
        }
        .onDisappear {
            
        }
    }
    
    /// 从剪切版获取图片
    func getQRCode() {
        if let qrCodeImage = CodeRecognizeAgent.shared.getQRCodeImageFromClipboard() {
            self.image = qrCodeImage
            transformText(qrCodeImage)
        } else {
            self.qrCodeText = "No image found in clipboard."
        }
    }
    
    /// 二维码识别成文字
    /// - Parameter image: 图片
    func transformText(_ image: NSImage) {
        if let text = CodeRecognizeAgent.shared.decodeQRCode(image) {
            self.qrCodeText = text
            self.isSuccess = true
        } else {
            self.qrCodeText = "Unable to decode QR code."
            self.isSuccess = false
        }
    }
}

struct CodeRecognize_Previews: PreviewProvider {
    static var previews: some View {
        CodeRecognizeView()
    }
}
