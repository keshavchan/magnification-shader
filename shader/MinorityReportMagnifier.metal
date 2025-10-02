//
//  MinorityReportMagnifier.metal
//  shader
//
//  Created by AI Assistant
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 loupe(
    float2 position,
    SwiftUI::Layer layer,
    float size,
    float2 center,
    float scale
) {
    // Calculate distance from center
    float2 offset = position - center;
    float distance = length(offset);
    
    // Create circular mask with smooth edges
    float radius = size;
    float circleMask = 1.0 - smoothstep(radius - 20, radius + 20, distance);
    
    // Calculate magnified position
    float2 magnifiedPosition = center + offset / scale;
    
    // Blend between normal and magnified
    float2 samplePosition = mix(position, magnifiedPosition, circleMask);
    
    return layer.sample(samplePosition);
}
