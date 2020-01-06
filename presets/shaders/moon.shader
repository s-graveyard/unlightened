shader_type canvas_item;
render_mode blend_mix;
 
void fragment(){
	float time = 24.0;
	vec2 uv = UV;
	//moon
	float t = 1.05;
	vec2 p = uv; 
	p.y += p.y*0.5 + (t - 1.8);
	p.x += (t-1.8)+p.x*0.5;
	vec3 basecol = vec3(199.0,190.0,100.0);
	basecol.r += smoothstep( 0.2, 10.1, t*0.1);
	basecol.g += smoothstep( 0.2, 10.1, t*0.1);
	basecol.b += smoothstep( 0.2, 10.1, t*0.1);
	vec3 suncol=basecol;
	vec2 m = vec2(-0.1,-0.1);
	suncol = suncol*smoothstep(0.1, 0.01 , length(p)) * smoothstep(1.5,0.1,uv.y);
	COLOR = vec4(suncol,0.1);
}