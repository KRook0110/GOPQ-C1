//
//  MapSheets.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 25/03/25.
//

import SwiftUI

struct MapSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImage: String? = nil
    
    @State private var currentAmount:CGFloat = 0
    @State private var lastAmount:CGFloat = 0
    
    
    let images = ["GOP Map", "GOP Map"]
    
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
                
                VStack(spacing: 20) {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selectedImage = imageName
                            }
                    }
                }
                .padding()
                
                Spacer()
            }
            
            if let selectedImage = selectedImage {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.selectedImage = nil
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.1))
                                        .clipShape(Circle())
                                }.padding()
                            }
                            ZoomableImage(imageName: selectedImage)
                        }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedImage)
            }
        }
    }
}


#Preview {
    MapSheet()
}
