//
//  NetworkStatsView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/16.
//

import SwiftUI
import Cocoa

struct NetworkStatsView: View {
    
    @State private var statusBarSpeed = "0K 0K"
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let queue = DispatchQueue(label: "com.goodick.networkspeed")
    
    let monitor = NetworkMonitor()
    
    var body: some View {
        Text(statusBarSpeed)
            .onAppear {
                
                statusItem.button?.title = statusBarSpeed
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    updateNetworkSpeed()
                    statusItem.button?.title = statusBarSpeed
                }.tolerance = 0.1
            }
    }
    
    func updateNetworkSpeed() {
        
        queue.async {
            let stats = monitor.getNetworkStats(.short)
            DispatchQueue.main.async {
//                networkSpeed = "\(stats.upload) ↑\n\(stats.download) ↓"
                statusBarSpeed = "\(stats.upload.replacingOccurrences(of: " ", with: "")) \(stats.download.replacingOccurrences(of: " ", with: ""))"
                print(statusBarSpeed + "\n")
            }
        }
    }
}

struct NetworkStatsView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkStatsView()
    }
}
