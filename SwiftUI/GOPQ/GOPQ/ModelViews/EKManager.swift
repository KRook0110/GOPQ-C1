//
//  EKManager.swift
//  GOPQ
//
//  Created by Shawn Andrew on 07/04/25.
//

import Foundation
import EventKit

@Observable
class EKManager {
    
    var showAlert: Bool = false
    
    init() {
        var store = EKEventStore()
        store.requestFullAccessToEvents { granted, err in
        }
    }
}
