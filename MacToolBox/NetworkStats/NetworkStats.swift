//
//  NetworkStats.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/16.
//

import Foundation

class NetworkStats {
    
    static func getNetworkStats() -> (downloadSpeed: Int, uploadSpeed: Int) {
        var downloadSpeed = 0
        var uploadSpeed = 0
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        // 获取系统中所有的网络接口
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            
            // 遍历所有的网络接口
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                
                // 只计算支持广播和点对点传输的接口
                if (flags & (IFF_UP|IFF_RUNNING|IFF_BROADCAST|IFF_POINTOPOINT)) == (IFF_UP|IFF_RUNNING|IFF_BROADCAST) {
                    guard let data = ptr!.pointee.ifa_data else {
                        ptr = ptr?.pointee.ifa_next
                        continue
                    }
                    let dlBytes = data.assumingMemoryBound(to: if_data.self).pointee.ifi_ibytes
                    let ulBytes = data.assumingMemoryBound(to: if_data.self).pointee.ifi_obytes
                    
                    let dlSpeed = Int(dlBytes - ptr!.pointee.ifa_data.assumingMemoryBound(to: if_data.self).pointee.ifi_ibytes)
                    let ulSpeed = Int(ulBytes - ptr!.pointee.ifa_data.assumingMemoryBound(to: if_data.self).pointee.ifi_obytes)
                    
                    let dlSpeedf = Int(dlBytes) / 1024
                    let ulSpeedf = Int(ulBytes) / 1024
                    
                    downloadSpeed += dlSpeedf
                    uploadSpeed += ulSpeedf
                    
                    print(ptr!.pointee.ifa_name, dlBytes, ulBytes, dlSpeed, ulSpeed, dlSpeedf, ulSpeedf, downloadSpeed, uploadSpeed)
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
//        print(downloadSpeed, uploadSpeed)
        return (downloadSpeed, uploadSpeed)
    }
}
