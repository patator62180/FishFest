shader_type spatial;

uniform sampler2D flow_texture : hint_normal;
uniform float size = 2.0;
uniform float flow_strength = 0.0075;
uniform float flow_speed = 0.01;

uniform sampler2D foam_texture;
uniform vec4 water_color : source_color;
uniform vec4 foam_color_light : source_color;
uniform vec4 foam_color_dark : source_color;
uniform vec2 foam_offset = vec2(0.1,0.1);

uniform float wave_height = 0.1;
uniform float wave_frequency = 10.0;

void vertex(){
    vec4 global_vertex = MODEL_MATRIX * vec4(VERTEX,1.0);
    float wave = sin(wave_frequency * global_vertex.z + global_vertex.x + TIME) * wave_height;
    
    VERTEX.y += wave;
}

void fragment() {
    vec2 flow_uv = (flow_speed / size) * TIME + UV;    
    
	vec4 flow_value = texture(flow_texture, flow_uv);
    flow_value = flow_value * flow_strength;
    
    vec2 foam_uv = (flow_value.xy + UV) * size;
    vec4 foam_dark = texture(foam_texture, foam_uv);
    foam_dark = mix(water_color, foam_color_dark, foam_dark);
    vec4 foam_light = texture(foam_texture, foam_uv + foam_offset);    
    
    vec4 foam = mix(foam_dark, foam_color_light, foam_light);
    
    ALBEDO = foam.rgb;
    ALPHA = foam.a;
}
