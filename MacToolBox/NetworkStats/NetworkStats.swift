//
//  NetworkStats.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/16.
//

import Foundation
import Network

/// 格式化类型
enum FormatType: String {
    // 10240
    case number
    // 10 k
    case short
    // 10 kB
    case middle
    // 10 KB/s
    case full
}

/// 单位
enum UnitType: String {
    case B
    case KB
    case MB
    case GB
}

/// 包装数据
struct ValueUnit {
    var value: Double
    var unit: UnitType
}

class NetworkMonitor {
    
    typealias SourceValue = (sent: Double, received: Double)
    
    private var prevReceived: UInt64 = 0
    private var prevSent: UInt64 = 0
    
    private var currentReceived: Double = 0.0
    private var currentSent: Double = 0.0
    
    func getNetworkStats() -> SourceValue {
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        var netInterface: UnsafeMutablePointer<ifaddrs>? = nil
        
        guard getifaddrs(&ifaddr) == 0 else {
            print("Failed to get network interface information.")
            return (0.0, 0.0)
        }
        
        netInterface = ifaddr
        
        while netInterface != nil {
            if let name = netInterface?.pointee.ifa_name, String(cString: name).hasPrefix("en") {
                // Found a network interface with valid name (e.g. "en0", "en1", etc.)
//                let interface = name
                let ifdata: UnsafeMutablePointer<if_data>? = unsafeBitCast(netInterface?.pointee.ifa_data, to: UnsafeMutablePointer<if_data>?.self)
                let sentBytes = UInt64(ifdata?.pointee.ifi_obytes ?? 0)
                let receivedBytes = UInt64(ifdata?.pointee.ifi_ibytes ?? 0)
                
                if sentBytes != 0 && receivedBytes != 0 {
                    
                    currentSent = prevSent == 0 ? 0.0 : Double(sentBytes - prevSent)
                    currentReceived = prevReceived == 0 ? 0.0 : Double(receivedBytes - prevReceived)
                    
                    print(sentBytes, receivedBytes)
                    print(currentSent, currentReceived)
                    
                    prevSent = sentBytes
                    prevReceived = receivedBytes
                }
            }
            netInterface = netInterface?.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
        
        return (currentSent, currentReceived)
    }
    
    func getNetworkStats(_ format: FormatType = .full, source: SourceValue?) -> (upload: String, download: String) {
        
        let stats = source ?? getNetworkStats()
        
        let sent = stats.sent
        let received = stats.received
        
        let uploadValueUnit = getValueUnit(sent)
        let downloadValueUnit = getValueUnit(received)
        
        let uploadValue = String(format: "%.1f", uploadValueUnit.value)
        let uploadUnit = uploadValueUnit.unit.rawValue
        
        let downloadValue = String(format: "%.1f", downloadValueUnit.value)
        let downloadUnit = downloadValueUnit.unit.rawValue
        
        var uploadString = ""
        var downloadString = ""
        
        switch format {
        case .number:
            uploadString = "\(sent)"
            downloadString = "\(sent)"
        case .short:
            uploadString = "\(uploadValue) \(uploadUnit.first!)"
            downloadString = "\(downloadValue) \(downloadUnit.first!)"
        case .middle:
            uploadString = "\(uploadValue) \(uploadUnit)"
            downloadString = "\(downloadValue) \(downloadUnit)"
        case .full:
            uploadString = "\(uploadValue) \(uploadUnit)/s"
            downloadString = "\(downloadValue) \(downloadUnit)/s"
        }
        
        return (uploadString, downloadString)
    }
    
    func getNetworkStats(_ format: FormatType = .full) -> (upload: String, download: String) {
        
        return getNetworkStats(format, source: nil)
    }
    
    func getValueUnit(_ value: Double) -> (value: Double, unit: UnitType) {
        if value < 1024 {
            return (value, UnitType.B)
        } else if value < 1024 * 1024 {
            return (value / 1024.0, UnitType.KB)
        } else if value < 1024 * 1024 * 1024 {
            return (value / 1024.0 / 1024.0, UnitType.MB)
        } else {
            return (value / 1024.0 / 1024.0 / 1024.0, UnitType.GB)
        }
    }
}
