#pragma question
uniform vec2 iResolution;
uniform float iGlobalTime;

//
// Let's make a distance function!
//
// We'll start with a circle. Its center should be at
// `point` == (0, 0), and its `radius` should match the value
// passed into `distanceFromCircle`.
//
float distanceFromCircle(vec2 point, float radius) {
  return 0.0;
}

void main() {
  vec2 uv = 2.0 * gl_FragCoord.xy / iResolution.xy - 1.0;
  float radius = (sin(iGlobalTime * 0.25) * 0.5 + 0.5) * 0.5 + 0.3;
  float dist = distanceFromCircle(uv, radius);

  // draw_distance is a little utility we're using from
  // https://www.shadertoy.com/view/XsyGRW
  //
  // It'll draw out your distance function for you, showing
  // negative distances in a dark orange and positive distances
  // in yellow -> blue.
  gl_FragColor = vec4(draw_distance(dist, uv), 1);
}
#pragma solution
uniform vec2 iResolution;
uniform float iGlobalTime;

float distanceFromCircle(vec2 point, float radius) {
  return length(point) - radius;
}

void main() {
  vec2 uv = 2.0 * gl_FragCoord.xy / iResolution.xy - 1.0;
  float radius = (sin(iGlobalTime * 0.25) * 0.5 + 0.5) * 0.5 + 0.3;
  float dist = distanceFromCircle(uv, radius);

  gl_FragColor = vec4(draw_distance(dist, uv), 1);
}
#pragma prefix
vec3 draw_line(float d);
float draw_solid(float d);
vec3 draw_distance(float d, vec2 p);
#pragma suffix
vec3 draw_line(float d) {
  const float aa = 3.0;
  const float thickness = 0.0025;
  return vec3(smoothstep(0.0, aa / iResolution.y, max(0.0, abs(d) - thickness)));
}

float draw_solid(float d) {
  return smoothstep(0.0, 3.0 / iResolution.y, max(0.0, d));
}

vec3 draw_distance(float d, vec2 p) {
  float t = clamp(d * 0.85, 0.0, 1.0);
  vec3 grad = mix(vec3(1, 0.8, 0.5), vec3(0.3, 0.8, 1), t);

  float d0 = abs(1.0 - draw_line(mod(d + 0.1, 0.2) - 0.1).x);
  float d1 = abs(1.0 - draw_line(mod(d + 0.025, 0.05) - 0.025).x);
  float d2 = abs(1.0 - draw_line(d).x);
  vec3 rim = vec3(max(d2 * 0.85, max(d0 * 0.25, d1 * 0.06125)));

  grad -= rim;
  grad -= mix(vec3(0.05, 0.35, 0.35), vec3(0.0), draw_solid(d));

  return grad;
}
