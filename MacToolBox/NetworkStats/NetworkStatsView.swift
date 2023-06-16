//
//  NetworkStatsView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/16.
//

import SwiftUI
import Cocoa

struct NetworkStatsView: View {
    
    @State private var networkSpeed = "0kB/s"
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let queue = DispatchQueue(label: "com.goodick.networkspeed")
    
    var body: some View {
        Text("Hello, World!")
            .padding()
            .onAppear {
                
                statusItem.button?.title = networkSpeed
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    print(timer)
                    updateNetworkSpeed()
                    statusItem.button?.title = networkSpeed
                }.tolerance = 0.1
                
            }
    }
    
    func updateNetworkSpeed() {
        print("updateNetworkSpeed")
        queue.async {
            print("async")
            let stats = NetworkStats.getNetworkStats()
            DispatchQueue.main.async {
                networkSpeed = "\(stats.downloadSpeed)KB/s ↓ \(stats.uploadSpeed)KB/s ↑"
                print(networkSpeed)
            }
        }
    }
}

struct NetworkStatsView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkStatsView()
    }
}
