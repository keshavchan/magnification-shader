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
    
    // Sample the color
    half4 color = layer.sample(samplePosition);
    
    // Add white stroke (4px width)
    float strokeWidth = 4.0;
    float strokeOuter = radius + strokeWidth / 2.0;
    float strokeInner = radius - strokeWidth / 2.0;
    float strokeMask = smoothstep(strokeInner - 1, strokeInner, distance) * 
                       (1.0 - smoothstep(strokeOuter, strokeOuter + 1, distance));
    
    // Add drop shadow
    float shadowDistance = 8.0;
    float shadowOffset = distance - shadowDistance;
    float shadowMask = smoothstep(radius + shadowDistance - 4, radius + shadowDistance, shadowOffset) * 
                       (1.0 - smoothstep(radius + shadowDistance, radius + shadowDistance + 8, shadowOffset));
    half4 shadowColor = half4(0.0, 0.0, 0.0, 0.5);
    
    // Blend shadow, then stroke, then color
    color = mix(color, shadowColor, shadowMask * 0.5);
    color = mix(color, half4(1.0, 1.0, 1.0, 1.0), strokeMask);
    
    return color;
}
