//
//  MinorityReportMagnifier.metal
//  shader
//
//  Created by AI Assistant
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 minorityReportMagnifier(
    float2 position,
    half4 color,
    float2 touchPosition,
    float magnification,
    float radius,
    float edgeSoftness
) {
    // Aggressive blue tint effect - very visible!
    return half4(color.r * 0.5, color.g * 0.7, color.b * 1.5, color.a);
}
