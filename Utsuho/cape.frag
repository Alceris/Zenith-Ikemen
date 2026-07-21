//When converting to SPV, specify version 450
//#version 450 core

#if __VERSION__ >= 450
	// VULKAN PATH
	#define COMPAT_TEXTURE texture
	layout(binding = 1) uniform UniformBufferObject  {
		vec4 x1x2x4x3;
		vec4 tint;
		vec3 add;
		vec3 mult;
		float alpha, gray, hue;
		int mask;
		bool isFlat, isRgba, isTrapez, neg;
		float iTime;
		vec2 iResolution;
		float aspectRatio;
		float sTime;
		float cameraPosX, cameraPosY, groundLevel, cameraScale;
	};
	layout(push_constant, std430) uniform u {
		vec4 palUV;
		float p0, p1, p2, p3, p4, p5, p6, p7;
		float p8, p9, p10, p11, p12, p13, p14, p15;
	};
	layout(binding = 2) uniform sampler2D tex;
	layout(binding = 3) uniform sampler2D pal;
	// Specifying the name of the bgl_texture to be used for GrabPass processing will execute the process of creating a BackBuffer
	// Do not specify the name of the bgl_texture if you do not use a BackBuffer
	layout(binding = 5) uniform sampler2D tex1;
	layout(location = 0) in vec2 texcoord;
	layout(location = 1) in vec2 pos;
	layout(location = 0) out vec4 FragColor;
#else
	// OPENGL / GLES PATH
	#define COMPAT_VARYING in
	#define COMPAT_TEXTURE texture
	#ifdef GL_ES
		precision highp float;
		precision highp int;
	#endif
	out vec4 FragColor;
	
	uniform sampler2D tex;
	uniform sampler2D pal;
	// Specifying the name of the bgl_texture to be used for GrabPass processing will execute the process of creating a BackBuffer
	// Do not specify the name of the bgl_texture if you do not use a BackBuffer
	uniform sampler2D tex1;
	
	uniform vec4 x1x2x4x3;
	uniform vec4 tint;
	uniform vec3 add, mult;
	uniform float alpha, gray, hue;
	uniform int mask;
	uniform bool isFlat, isRgba, isTrapez, neg;
	
	uniform float p0, p1, p2, p3, p4, p5, p6, p7;
	uniform float p8, p9, p10, p11, p12, p13, p14, p15;

	uniform float iTime;
	uniform vec2 iResolution;
	uniform float aspectRatio;
	uniform float sTime;
	uniform float cameraPosX, cameraPosY, groundLevel, cameraScale;

	COMPAT_VARYING vec2 texcoord;
	COMPAT_VARYING vec2 pos;
#endif

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 hue_shift(vec3 color, float dhue) {
	vec3 colorhsv = rgb2hsv(color);
	colorhsv.x = mod(colorhsv.x+dhue, 1.0);
	return hsv2rgb(colorhsv);
}

// ----------------------

void main() {
	vec2 uv = texcoord;


	vec4 c;
	vec3 neg_base = vec3(1.0);
	vec3 final_add = add;
	vec4 final_mul = vec4(mult, alpha);

	// Select flat color or textures
	if (isFlat) {
		c = tint; 

		// Treat flat colors like RGBA for math consistency
		neg_base *= c.a;
		final_add *= c.a;
		final_mul.rgb *= alpha;
	} else {
		//vec2 uv = texcoord;
		if (isTrapez) {
			vec2 bounds = mix(x1x2x4x3.zw, x1x2x4x3.xy, uv.y);
			float gap = bounds[1] - bounds[0];
			#ifdef GL_ES
				if (abs(gap) < 0.0001) gap = 0.0001;
			#endif
			uv.x = (gl_FragCoord.x - bounds[0]) / gap;
		}
		c = COMPAT_TEXTURE(tex, uv);

		// Select with or without palette
		if (isRgba) {
			if (mask == -1) c.a = 1.0;
			neg_base *= c.a;
			final_add *= c.a;
			final_mul.rgb *= alpha;
		} else {
			// Palette lookup
			#if __VERSION__ >= 450
				c = COMPAT_TEXTURE(pal, vec2(palUV[0]+palUV[2]*c.r*0.9966, palUV[1]));
			#else
				c = COMPAT_TEXTURE(pal, vec2(c.r*0.9966, 0.5));
			#endif
			if (mask == -1) c.a = 1.0;
		}
	}

	vec2 scaledPos = vec2(gl_FragCoord.x-(iResolution.x/2), -gl_FragCoord.y+(iResolution.y-(groundLevel*iResolution.y/240)))/iResolution/cameraScale; // I fucking hate this
	vec2 screen = vec2(p0, p1); // ScreenWidth and ScreenHeight triggers
	vec2 camerapos = vec2(cameraPosX, cameraPosY/cameraScale)*p2; // I don't know why I have to divide specifically the Y axis, I don't know why I have to multiply this by 4/3 divided by the current aspect ratio, but that's just how it works for some reason
    // fract makes the value wrap around between 0 to 1
	vec2 capeUV = fract(((scaledPos)+(camerapos/screen))*screen/128+vec2(-p3,p3)); // Apply everything and make it continuously move diagonally up right
	// All of that was determined by trial and error and just gets the X and Y distance from, I think, the centerpoint of the stage

    // Get color from tex1
    vec4 capeSprite = texture(tex1, capeUV);

	// Get a mask of magenta parts of the sprite
	float capeMask = float(c.rgb == vec3(1, 0, 1));

    // Mix the cape sprite onto magenta parts
	c = mix(c, capeSprite, capeMask);

	// Apply PalFX
	// Hue
	if (hue != 0.0) {
		c.rgb = hue_shift(c.rgb, hue);
	}
	// Invertall
	if (neg) {
		c.rgb = neg_base - c.rgb;
	}
	// Color
	c.rgb = mix(vec3((c.r + c.g + c.b) / 3.0), c.rgb, 1.0 - gray);
	// Add
	c.rgb += final_add;
	// Mul
	c *= final_mul;

	// Apply tint
	// Sprites only, because flat colors are already tinted
	if (!isFlat) {
		c.rgb = mix(c.rgb, tint.rgb * c.a, tint.a);
	}

    FragColor = c;

}