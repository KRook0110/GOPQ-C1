//
//  ZoomableImage.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 06/04/25.
//

import SwiftUI

struct ZoomableImage: View {
    
    private let image: Image
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @GestureState private var isDetectingDoubleTap = false
    
    init(image: Image) {
        self.image = image
    }
    
    init(imageName: String) {
        self.image = Image(imageName)
    }
    
    var body: some View {
        GeometryReader { geometry in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(doubleTapGesture(size: geometry.size))
                .gesture(SimultaneousGesture(
                    magnificationGesture,
                    dragGesture
                ))
                .animation(.interactiveSpring(), value: offset)
                .animation(.interactiveSpring(), value: scale)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / self.lastScale
                self.lastScale = value
                
                let newScale = self.scale * delta
                self.scale = min(max(newScale, 1), 3.0)
            }
            .onEnded { _ in
                self.lastScale = 1.0
            }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let newOffset = CGSize(
                    width: self.lastOffset.width + value.translation.width,
                    height: self.lastOffset.height + value.translation.height
                )
                self.offset = newOffset
            }
            .onEnded { _ in
                self.lastOffset = self.offset
            }
    }
    
    private func doubleTapGesture(size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                if scale > 1 {
                    withAnimation {
                        scale = 1.0
                        offset = .zero
                        lastOffset = .zero
                    }
                } else {
                    withAnimation {
                        scale = 2.0
                    }
                }
            }
    }
}



