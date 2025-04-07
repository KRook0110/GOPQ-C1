//
//  DataContext.swift
//  GOPQ
//
//  Created by Shawn Andrew on 07/04/25.
//

import Foundation
import SwiftData


class ModelManager {
    static let shared: ModelContainer = {
        
        let configuration = ModelConfiguration(for: ScheduleItemData.self)
        
        do {
            return try ModelContainer(for: ScheduleItemData.self, configurations: configuration)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
    
}
