#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 Ripple(
    float2 position,
    SwiftUI::Layer layer,
    float2 origin,
    float time,
    float amplitude,
    float frequency,
    float decay,
    float speed
) {
    float distance = length(position - origin);
    float delay = distance / speed;
    
    if (time < delay) {
        return layer.sample(position);
    }
    
    float adjustedTime = time - delay;
    float fadeOut = exp(-decay * adjustedTime);
    float wave = sin(frequency * adjustedTime) * amplitude * fadeOut;
    
    float2 direction = normalize(position - origin);
    float2 offset = direction * wave;
    
    return layer.sample(position + offset);
}
