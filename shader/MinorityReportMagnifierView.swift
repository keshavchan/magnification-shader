//
//  MinorityReportMagnifierView.swift
//  shader
//
//  Created by AI Assistant
//

import SwiftUI
import Metal

struct MinorityReportMagnifierView: View {
    // The image to display and apply shader effect to
    var image: Image?

    // Fixed shader parameters - no interactions for now
    private let touchPosition = CGPoint(x: 0.5, y: 0.5) // center of screen
    private let magnification: Float = 2.0
    private let radius: Float = 0.15
    private let edgeSoftness: Float = 0.02

    var body: some View {
        GeometryReader { proxy in
            // Content layer that the shader will sample
            contentView
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                // Flatten the subtree so the shader samples from a single layer.
                .compositingGroup()
                .layerEffect(
                    ShaderLibrary.minorityReportMagnifier(
                        .float2(touchPosition),
                        .float(magnification),
                        .float(radius),
                        .float(edgeSoftness)
                    ),
                    maxSampleOffset: CGSize(
                        width: max(100, proxy.size.width * 0.5),
                        height: max(100, proxy.size.height * 0.5)
                    )
                )
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if let image {
            image
                .resizable()
        } else {
            // Transparent overlay when no image
            Color.clear
        }
    }
}


#Preview {
    // Preview with a placeholder; you can also preview with an asset if available:
    // MinorityReportMagnifierView(image: Image("sea_image"))
    MinorityReportMagnifierView(image: nil)
}
