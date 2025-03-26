//
//  MapSheets.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 25/03/25.
//

import SwiftUI

struct MapSheets: View {
    @State private var showMapSheet = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Button("Sheets Modal") {
                    showMapSheet = true
                }.buttonStyle(.borderedProminent)
            }
            .padding()
            .sheet(isPresented: $showMapSheet) {
                BottomSheetView()
                    .presentationBackground(.clear)
                    .background(.clear)
            }
        }
    }
}

struct BottomSheetView: View {
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
                            
                            Image(selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .scaleEffect(1 + currentAmount)
                                .gesture(
                                    MagnificationGesture().onChanged { value in
                                        currentAmount = value - 1
                                    }
                                        .onEnded { value in withAnimation(.spring()) { currentAmount = 0 }
                                        }
                                )
                        }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedImage)
            }
        }
    }
}

#Preview {
    BottomSheetView()
}

#Preview {
    MapSheets()
}
