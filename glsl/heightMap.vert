//vertex shader that displaces vertices in Y based on a texture
//author: Skeel Lee <skeel@skeelogy.com>

uniform sampler2D uTexture;
uniform vec2 uTexelSize;
uniform vec2 uTexelWorldSize;
uniform float uHeightMultiplier;

varying vec3 vWorldPos;
varying vec3 vNormal;
varying vec2 vUv;

void main() {

    vUv = uv;

    //displace y based on texel value
    vec4 t = texture2D(uTexture, vUv) * uHeightMultiplier;
    vec3 displacedPos = vec3(position.x, t.r, position.z);

    //find normal
    vec2 du = vec2(uTexelSize.r, 0.0);
    vec2 dv = vec2(0.0, uTexelSize.g);
    vec3 vecPosU = vec3(displacedPos.x + uTexelWorldSize.r,
                        texture2D(uTexture, vUv + du).r * uHeightMultiplier,
                        displacedPos.z) - displacedPos;
    vec3 vecNegU = vec3(displacedPos.x - uTexelWorldSize.r,
                        texture2D(uTexture, vUv - du).r * uHeightMultiplier,
                        displacedPos.z) - displacedPos;
    vec3 vecPosV = vec3(displacedPos.x,
                        texture2D(uTexture, vUv + dv).r * uHeightMultiplier,
                        displacedPos.z - uTexelWorldSize.g) - displacedPos;
    vec3 vecNegV = vec3(displacedPos.x,
                        texture2D(uTexture, vUv - dv).r * uHeightMultiplier,
                        displacedPos.z + uTexelWorldSize.g) - displacedPos;
    vNormal = 0.25 * (normalize(cross(vecPosU, vecPosV)) + normalize(cross(vecPosV, vecNegU)) + normalize(cross(vecNegU, vecNegV)) + normalize(cross(vecNegV, vecPosU)));

    vec4 pos = vec4(displacedPos, 1.0);
    vWorldPos = (modelMatrix * pos).rgb;

    gl_Position = projectionMatrix * modelViewMatrix * pos;
}