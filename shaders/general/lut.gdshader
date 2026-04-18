shader_type canvas_item;

// color restriction shader using a lookup table (LUT)
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D lut;
uniform float lut_size = 16.0;

void fragment(){
  // pick texture from screen
	vec4 color = texture(screen_texture,SCREEN_UV);
  // lut size to use (256px x lut_size)
  vec2 size = vec2(256. - 1., lut_size - 1.);
  // calculating lookup UV based on the color
  float u  =  floor(color.b * size.y) / size.y * (size.x - size.y);
        u  = (floor(color.r * size.y * 0.97) / size.y *  size.y) + u;
        u /= size.x;
  float v  = 1.0 - (floor(color.g * size.y) / size.y);
  // picking the right color from the lut
  vec4 col = texture(lut, vec2(u,v));
  // using color from lut and alpha channel from original 
  // mix so part of the original is preserved
  vec3 mixed = mix(color.rgb, col.rgb, 0.25);
  COLOR = vec4(mixed, color.a);
}

