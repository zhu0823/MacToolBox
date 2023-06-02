//
//  MacToolBoxApp.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import SwiftUI

@main
struct MacToolBoxApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
}

