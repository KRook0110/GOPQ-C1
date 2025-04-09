//
//  MapSheets.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 25/03/25.
//

import SwiftUI

struct MapSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentAmount:CGFloat = 0
    @State private var lastAmount:CGFloat = 0


    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .padding()
                }

                ZoomableImage(imageName: "GOP map")

                Spacer()
            }

            
        }
    }
}


//#Preview {
//    MapSheet()
//}
