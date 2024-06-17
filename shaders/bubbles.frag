#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;
uniform float countTimes;

out vec4 fragColor;
#define COUNT 10.
#define COL1 vec3(0, 0, 0)/255.
#define COL2 vec3(82, 255, 161)/255.


#define rand1(p) fract(sin(p* 78.233)* 43758.5453)


void main() {
    vec2 fragCoord = FlutterFragCoord().xy;

    vec2 uv = fragCoord / iResolution.xy ;

    float sum = 0.;

    for(float i=0.; i<COUNT; i++){
        float dir = mod(i, 3.)*2.-1.;
        float a = iTime + i + rand1(i) * 3.1415;
        float l = length(vec2(uv.x+sin(a)*.025*dir, uv.y+cos(a*0.5)*.25)*dir);

        sum+=countTimes/l;
    }

    float fd = smoothstep(.7425, .75,  sum);

    vec3 col = mix(COL1, COL2, clamp(fd + 0.0, 0., 1.));

    fragColor = vec4(col,1.0);
}