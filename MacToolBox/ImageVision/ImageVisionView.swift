//
//  ImageVisionView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import SwiftUI

struct ImageVisionView: View {
    
    @State private var image: NSImage? = nil
    @State private var text: String = ""
    
    var body: some View {
        HStack {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                    .padding()
            } else {
                Rectangle()
                    .foregroundColor(Color.clear)
            }
            
            VStack {
                TextEditor(text: $text)
                
                HStack {
                    Button("识别") {
                        imageVisionDetect()
                    }
                    Button("拷贝") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(self.text, forType: .string)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            imageVisionDetect()
        }
    }
    
    func imageVisionDetect() {
        
        guard let image = CodeRecognizeAgent.shared.getQRCodeImageFromClipboard() else { return }
        
        self.image = image
        
        let result = ImageAgent.shared.showSupportsLanguages()
        print("showSupportsLanguages:", result)
        
        ImageAgent.shared.loadImage(image) { text in
            print("loadImage:", text ?? "")
            if let text = text {
                self.text = text
            }
        }

    }
}

struct TextVisionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageVisionView()
    }
}
