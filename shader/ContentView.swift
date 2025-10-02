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

    var body: some View {
        ZStack {
            // Simple background
            Color.black.ignoresSafeArea()
            
            // Image with magnification shader - proper approach
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .visualEffect { content, proxy in
                        content
                            .layerEffect(
                                ShaderLibrary.loupe(
                                    .float(80),
                                    .float2(
                                        proxy.size.width / 2,
                                        proxy.size.height / 2
                                    ),
                                    .float(2.0)
                                ),
                                maxSampleOffset: CGSize(width: 300, height: 300)
                            )
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
