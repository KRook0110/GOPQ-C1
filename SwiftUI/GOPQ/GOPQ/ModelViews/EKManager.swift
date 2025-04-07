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
    var messageTemp = "NotYet"
    
    
    init() {
        let store = EKEventStore()
        
        store.requestFullAccessToEvents { granted, err in
            if granted {
                self.messageTemp = "Granted"
            }
            else {
                self.messageTemp = "Denied"
            }
            
        }
    }
}
