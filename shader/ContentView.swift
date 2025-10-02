//
//  ContentView.swift
//  shader
//
//  Created by keshav on 02/10/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var touchLocation: CGPoint = .zero
    let startDate = Date()

    var body: some View {
        ZStack {
            // Simple background
            Color.black.ignoresSafeArea()
            
            // Image with animated magnification shader
            if let uiImage = selectedImage {
                TimelineView(.animation) { timeline in
                    GeometryReader { geometry in
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .visualEffect { content, proxy in
                                content
                                    .layerEffect(
                                        ShaderLibrary.loupe(
                                            .float(80),
                                            .float2(touchLocation),
                                            .float(2.0),
                                            .float(startDate.timeIntervalSinceNow)
                                        ),
                                        maxSampleOffset: CGSize(width: 300, height: 300)
                                    )
                            }
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        touchLocation = value.location
                                    }
                            )
                            .onAppear {
                                // Initialize to center
                                touchLocation = CGPoint(
                                    x: geometry.size.width / 2,
                                    y: geometry.size.height / 2
                                )
                            }
                    }
                }
            }
            
            // Button
            VStack {
                Spacer()
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text(selectedImage == nil ? "Select Photo" : "Change Photo")
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
