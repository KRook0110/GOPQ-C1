//
//  UserDataController.swift
//  GOPQ
//
//  Created by Shawn Andrew on 03/04/25.
//

import Foundation
import SwiftData
import EventKit

@Observable
class UserData {
    var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    init() {
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        
    }
    
}
