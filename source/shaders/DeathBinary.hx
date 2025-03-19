package shaders;

import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;

class BinaryShader extends FlxShader
{
    @glFragmentSource('
    #pragma header
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    #define fragColor gl_FragColor
    #define mainImage main


    #define RAIN_SPEED 13.75 // Speed of rain droplets
    #define DROP_SIZE  7.0  // Higher value lowers, the size of individual droplets

    float rand(vec2 co){
        return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
    }

    float rchar(vec2 outer, vec2 inner, float globalTime) {
        //return float(rand(floor(inner * 2.0) + outer) > 0.9);
        
        vec2 seed = floor(inner * 4.0) + outer.y;
        if (rand(vec2(outer.y, 23.0)) > 0.98) {
            seed += floor((globalTime + rand(vec2(outer.y, 49.0))) * 3.0);
        }
        
        return float(rand(seed) > 0.5);
    }

    void mainImage() {

        vec2 position = fragCoord.xy / iResolution.xy;
        vec2 uv = vec2(position.x, position.y);
        position.x /= iResolution.x / iResolution.y;
        float globalTime = iTime * RAIN_SPEED;
        
        float scaledown = DROP_SIZE;
        float rx = fragCoord.x / (40.0 * scaledown);
        float mx = 40.0*scaledown*fract(position.x * 30.0 * scaledown);
        vec4 result;
        
        if (mx > 12.0 * scaledown) {
            result = vec4(0.0);
        } else 
        {
            float x = floor(rx);
            float r1x = floor(fragCoord.x / (15.0));
            

            float ry = position.y*600.0 + rand(vec2(x, x * 3.0)) * 100000.0 + globalTime* rand(vec2(r1x, 23.0)) * 120.0;
            float my = mod(ry, 15.0);
            if (my > 12.0 * scaledown) {
                result = vec4(0.0);
            } else {
            
                float y = floor(ry / 15.0);
                
                float b = rchar(vec2(rx, floor((ry) / 15.0)), vec2(mx, my) / 12.0, globalTime);
                float col = max(mod(-y, 24.0) - 4.0, 0.0) / 20.0;
                vec3 c = col < 0.8 ? vec3(1.0, 0.0 / 0.8, 0.0) : mix(vec3(1.0, 0.0, 0.0), vec3(1.0), (0.0 - 0.8) / 0.2);
                
                result = vec4(c * b, 1.0)  ;
            }
        }
        
        position.x += 0.05;

        scaledown = DROP_SIZE;
        rx = fragCoord.x / (40.0 * scaledown);
        mx = 40.0*scaledown*fract(position.x * 30.0 * scaledown);
        
        if (mx > 12.0 * scaledown) {
            result += vec4(0.0);
        } else 
        {
            float x = floor(rx);
            float r1x = floor(fragCoord.x / (12.0));
            

            float ry = position.y*700.0 + rand(vec2(x, x * 3.0)) * 100000.0 + globalTime* rand(vec2(r1x, 23.0)) * 120.0;
            float my = mod(ry, 15.0);
            if (my > 12.0 * scaledown) {
                result += vec4(0.0);
            } else {
            
                float y = floor(ry / 15.0);
                
                float b = rchar(vec2(rx, floor((ry) / 15.0)), vec2(mx, my) / 12.0, globalTime);
                float col = max(mod(-y, 24.0) - 4.0, 0.0) / 20.0;
                vec3 c = col < 0.8 ? vec3(1.0, 0.0 / 0.8, 0.0) : mix(vec3(1.0, 0.0, 0.0), vec3(0.0), (0.0 - 0.8) / 0.2);
                
                result += vec4(c * b, 1.0)  ;
            }
        }
        
        result = result * length(texture(iChannel0,uv).rgb) + 0.02 * vec4(0.,texture(iChannel0,uv).g,0.,1.);
        if(result.b < 0.5)
        result.b = result.g * 0.5 ;
        fragColor = result;
    }
    ')
    public function new() {
        super();
    }
    public function createPixels(){
        var pixel:BinaryMovement = new BinaryMovement();
        var pixels:ShaderFilter = new ShaderFilter(pixel);
        if(FlxG.camera.filters != null)
            FlxG.camera.filters.push(pixels);
    };
    public function update(elapsed:Float) {
        iTime.value[0] = FlxG.elapsed;
    }
}
class BinaryMovement extends FlxShader {
    @glFragmentSource('
    #pragma header
         uniform float thingSize;
    	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    	
    	#define pxSize 1.5

    	void main() {
    		vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
    		
    		float plx = openfl_TextureSize.x * pxSize  / 500.0;
    		float ply = openfl_TextureSize.y * pxSize  / 275.0;
    		
    		float dx = plx * (1.0 / openfl_TextureSize.x);
    		float dy = ply * (1.0 / openfl_TextureSize.y);
    		
    		uv.x = dx * floor(uv.x / dx);
    		uv.y = dy * floor(uv.y / dy);
    		
    		gl_FragColor = flixel_texture2D(bitmap, uv);
	}')
    public function new() {
        super();
    }
}