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
    float scale,
    float time
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
    
    // Add animated background effect - ALWAYS VISIBLE
    // Create animated waves
    float wave1 = sin(position.x * 0.01 + time * 3.0) * cos(position.y * 0.01 + time * 2.0);
    float wave2 = sin(position.x * 0.015 - time * 2.5) * cos(position.y * 0.012 + time * 3.5);
    float combinedWave = (wave1 + wave2) * 0.5;
    
    // Color shimmer effect - cycles through colors (VERY VISIBLE)
    half3 shimmerColor = half3(
        0.5 + 0.5 * sin(time * 2.0 + combinedWave * 2.0),
        0.5 + 0.5 * sin(time * 2.0 + combinedWave * 2.0 + 2.094),  // 2π/3 offset
        0.5 + 0.5 * sin(time * 2.0 + combinedWave * 2.0 + 4.189)   // 4π/3 offset
    );
    
    // Apply shimmer to background (stronger outside magnified area)
    float backgroundStrength = mix(0.4, 0.1, circleMask);
    color.rgb = color.rgb * (1.0 + shimmerColor * backgroundStrength);
    
    // Add wiggly color effect in the magnified area
    if (circleMask > 0.1) {
        // Create wiggly pattern based on position
        float wiggle = sin(position.x * 0.05) * cos(position.y * 0.05);
        
        // Color shift - creates rainbow-like wiggles
        float colorShift = wiggle * 0.3;
        half3 wigglyColor = half3(
            color.r * (1.0 + colorShift),
            color.g * (1.0 + sin(wiggle * 3.0) * 0.2),
            color.b * (1.0 + cos(wiggle * 2.0) * 0.2)
        );
        
        // Apply wiggly effect only in magnified area
        color.rgb = mix(color.rgb, wigglyColor, circleMask * 0.5);
    }
    
    // Add very subtle drop shadow
    float shadowDistance = 4.0;
    float shadowOffset = distance - shadowDistance;
    float shadowMask = smoothstep(radius + shadowDistance - 2, radius + shadowDistance, shadowOffset) * 
                       (1.0 - smoothstep(radius + shadowDistance, radius + shadowDistance + 6, shadowOffset));
    half4 shadowColor = half4(0.0, 0.0, 0.0, 0.3);
    
    // Blend shadow with color (very subtle)
    color = mix(color, shadowColor, shadowMask * 0.2);
    
    // Add thin 1px white stroke
    float strokeWidth = 1.0;
    float strokeOuter = radius + strokeWidth / 2.0;
    float strokeInner = radius - strokeWidth / 2.0;
    float strokeMask = smoothstep(strokeInner - 0.5, strokeInner, distance) * 
                       (1.0 - smoothstep(strokeOuter, strokeOuter + 0.5, distance));
    
    // Blend white stroke on top
    color = mix(color, half4(1.0, 1.0, 1.0, 1.0), strokeMask);
    
    return color;
}
