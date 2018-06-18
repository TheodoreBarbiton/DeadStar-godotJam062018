shader_type canvas_item;

// Which color you want to change
uniform vec4 key = vec4(1.0,0,0,1.0);
// Which color to replace it with
uniform vec4 colour : hint_color;
// How much tolerance for the replacement color (between 0 and 1)
uniform float tolerance;

void fragment() {
    // Get color from the sprite texture at the current pixel we are rendering
    vec4 colourOriginal = texture(TEXTURE, UV);
    vec3 col = colourOriginal.rgb;
    // Get a rough degree of difference between the texture color and the color key
    vec3 diff3 = col - key.rgb;
    float m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b));
    // Change color of pixels below tolerance threshold, while keeping shades if any (a bit naive, there may better ways)
    float brightness = length(col);
    col = mix(col, colour.rgb * brightness, step(m, tolerance));
    // Assign final color for the pixel, and preserve transparency
    COLOR = vec4(col.rgb, colourOriginal.a);
}