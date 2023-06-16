//
//  ContentView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Int? = 0
    
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                NavigationLink(destination: CodeRecognizeView()) {
                    Text("识别二维码")
                }
                NavigationLink(destination: DetailView(text: "3")) {
                    Text("生成二维码")
                }
                NavigationLink(destination: ImageVisionView()) {
                    Text("识图生字")
                }
                NavigationLink(destination: NetworkStatsView()) {
                    Text("网速监控")
                }
            }
            .padding([.top])
            .listStyle(SidebarListStyle())
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                    print(event.modifierFlags, " ", event.keyCode)
                    return handleKeyboardEvent(event)
                }
            }
        }
    }
    
    
    /// 处理键盘快捷键
    /// - Parameter event: event description
    /// - Returns: description
    func handleKeyboardEvent(_ event: NSEvent) -> NSEvent? {
        if event.modifierFlags.contains(.command) {
            switch event.keyCode {
            case 18:
                selection = 0
            case 19:
                selection = 1
            case 20:
                selection = 2
            default:
                return event
            }
            return nil
        }
        return event
    }
}

struct DetailView: View {
    var text: String
    var body: some View {
        Text(text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
