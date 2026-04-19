shader_type canvas_item;

// color restriction shader using a lookup table (LUT)
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform sampler2D lut;
uniform float lut_size = 16.0;

void fragment(){
  // pick texture from screen
  vec4 color = textureLod(screen_texture,SCREEN_UV, 0.);
  // lut size to use (256px x lut_size)
  vec2 size = vec2(256. - 1., lut_size - 1.);
  // calculating lookup UV based on the color (left)
  float u  =  floor(color.b * size.y) / size.y * (size.x - size.y);
        u  = (floor(color.r * size.y) / size.y *  size.y) + u;
        u /= size.x;
  float v  = 1. - (ceil(color.g * size.y) / size.y);
  // picking the color from the lut
  vec4 col = texture(lut, vec2(u,v));

  // calculating lookup UV based on the color (right)
  u =  ceil(color.b * size.y) / size.y * (size.x - size.y);
        u  = (ceil(color.r * size.y) / size.y *  size.y) + u;
        u /= size.x;
  v  = 1. - (ceil(color.g * size.y) / size.y);
  
  // picking the color from the lut again
  vec4 col2 = texture(lut, vec2(u,v));

  // using color from lut and alpha channel from original 
  // mix so part of the original is preserved
  vec3 found_color;
  found_color.r = mix(col.r, col2.r, fract(color.r * size.y));
  found_color.g = mix(col.g, col2.g, fract(color.g * size.y));
  found_color.b = mix(col.b, col2.b, fract(color.b * size.y));

  vec3 mixed = mix(color.rgb, found_color.rgb, .25);
  COLOR = vec4(mixed, color.a);
}

