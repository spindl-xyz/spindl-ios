//
//  HostManager.swift
//
//  Chooses the base host URL for the application to use

import Foundation
import Combine

class HostManager {
    static let shared = HostManager()
    
    @Published var selectedHost: Host = {
        let hostNum: Int? = UserDefaults.standard.value(for: .host)
        
        if let hostNum = hostNum, //will return 0 if not found, so started enum at 1
           let host = Host(rawValue: hostNum) {
            return host
        } else {
//            #if DEBUG
            return .development
//            #else
//            return .production
//            #endif
        }
    }()
    
    var url: URL {
        return URL(string: selectedHost.url)!
    }
    
    var availableHosts: [Host] = Host.allCases
    
    private init() {
        
    }
    
    func updateHost(host: Host) {
        UserDefaults.standard.set(value: host.rawValue, for: .host)
        self.selectedHost = host
    }

}
