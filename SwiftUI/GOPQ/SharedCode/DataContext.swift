//
//  DataContext.swift
//  GOPQ
//
//  Created by Shawn Andrew on 07/04/25.
//

import Foundation
import SwiftData

#if os(iOS)
class ModelManager {
    static let shared = ModelManager()
    
    let container: ModelContainer
    let mainContext: ModelContext
    let backgroundContext: ModelContext
    
    private init() {
        let schema = Schema([ScheduleItemData.self])
        let config = ModelConfiguration("GOPQ", schema: schema)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
            mainContext = ModelContext(container)
            backgroundContext = ModelContext(container)
            backgroundContext.autosaveEnabled = false
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    func saveBackground() {
        try? backgroundContext.save()
    }
}
#endif
