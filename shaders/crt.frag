#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uRandom;
uniform sampler2D uTexture;

out vec4 fragColor;


float warp = 0.7;
float scan = 0.75;

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    

    vec2 dc = abs(0.5 - uv);
    dc *= dc;
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.25 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.5 * warp)); uv.y += 0.5;

    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    } else {

        float scanLines = 0.5 + 0.5 * sin(pos.y * 1.0 + uTime * 25.0);
        
        float rollingBar = sin(uv.y * 2.0 - uTime * 5000);
        rollingBar = clamp(rollingBar + 0.9, 0.95, 1.0);

        float jitter = (uRandom > 0.999) ? 0.05 : (uRandom > 0.99) ? 0.02 : (uRandom > 0.97) ? 0.005 : 0.0;
        vec2 warpedUv = uv;
        warpedUv.y += jitter * sin(uTime * 100.0);

        vec4 color = texture(uTexture, warpedUv);
        

        float apply = abs(scanLines * scan);
        vec3 finalRGB = color.rgb * rollingBar;
        finalRGB = mix(finalRGB, vec3(0.0), apply * 0.2);

        fragColor = vec4(finalRGB, 1.0);
    }
}