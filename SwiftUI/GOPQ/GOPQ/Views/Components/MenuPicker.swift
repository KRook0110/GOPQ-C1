//
//  MenuPicker.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 07/04/25.
//
// First define an enum for the alert options

import SwiftUI

enum MenuOption: String, CaseIterable, Identifiable {
    case none = "None"
    case fiveMin = "5 minutes before"
    case fifteenMin = "15 minutes before"
    case thirtyMin = "30 minutes before"
    case oneHour = "1 hour before"
    
    var id: String { self.rawValue }
    
    // Convert to minutes for easier calculation
    var minutes: Int?  {
        switch self {
        case .none: return nil
        case .fiveMin: return 5
        case .fifteenMin: return 15
        case .thirtyMin: return 30
        case .oneHour: return 60
        }
    }
}

struct MenuPicker: View {
    let label: String
    @Binding var selectedOption: MenuOption
    @State private var showCustomAlert = false
    
    var body: some View {
        LabeledContent {
            Menu {
                ForEach(MenuOption.allCases) { option in
                    Button(action: {
                        selectedOption = option
                    }) {
                        if selectedOption == option {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption.rawValue)
                        .foregroundStyle(.white.opacity(0.7))
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.vertical, 6)
                .background(.clear)
                .cornerRadius(8)
            }
        } label: {
            Text(label)
        }
    }
}
