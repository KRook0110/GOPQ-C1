//
//  BorderLine.swift
//  GOPQ
//
//  Created by Shawn Andrew on 26/03/25.
//

import SwiftUI

struct BorderLine: View {
    var body: some View {
        Rectangle()
            .fill( LinearGradient(
                    colors: [
                        .gray.opacity(0.1),
                        .gray.opacity(0.4),
                        .gray.opacity(0.1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
            ) )
            .frame(width: .infinity, height: 2)
    }
}

