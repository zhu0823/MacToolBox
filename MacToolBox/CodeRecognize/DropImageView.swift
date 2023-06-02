//
//  DropImageView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import SwiftUI

struct DropImageView: View {
    @Binding var image: NSImage?
    @State private var drapOver = false
    var itemHandler: (NSImage) -> Void
    
    var body: some View {
        VStack {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("""
                     1、Drag and Drop image here
                     2、Press [cmd + v]
                     3、Click The recognize button
                     """)
            }
        }
        .onDrop(of: ["public.file-url"], isTargeted: $drapOver) { providers -> Bool in
            
            providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { data, error in
                if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                    if let image = NSImage(contentsOf: url) {
                        self.image = image
                        self.itemHandler(image)
                    }
                }
            })
            return true
        }
        .border(drapOver ? Color.green : Color.clear, width: 2)
        
    }
}

struct DropImage_Previews: PreviewProvider {
    static var previews: some View {
        DropImageView(image: .constant(nil)) { img in
            
        }
    }
}
