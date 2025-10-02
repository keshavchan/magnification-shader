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
            
            // Image with shader - SIMPLE APPROACH
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .colorEffect(
                        ShaderLibrary.minorityReportMagnifier(
                            .float2(0.5, 0.5),
                            .float(2.0),
                            .float(0.15),
                            .float(0.02)
                        )
                    )
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
