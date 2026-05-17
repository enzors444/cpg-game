varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_color;
uniform float u_threshold;
uniform float u_fill_all;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);

    if (tex.a <= 0.01) {
        discard;
    }

    if (u_fill_all > 0.5) {
        gl_FragColor = vec4(u_color.rgb, tex.a * v_vColour.a * u_color.a);
        return;
    }

    vec3 original = tex.rgb * v_vColour.rgb;
    float brilho = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    float vermelho = tex.r - max(tex.g, tex.b);
    float quente = tex.r - tex.b;
    float maior = max(tex.r, max(tex.g, tex.b));
    float menor = min(tex.r, min(tex.g, tex.b));
    float saturacao = maior - menor;
    float nao_preto = smoothstep(0.02, u_threshold * 0.55, brilho);
    float mascara_vermelha = smoothstep(0.08, 0.22, vermelho);
    float mascara_marrom = smoothstep(0.16, 0.32, quente) * smoothstep(0.12, 0.28, saturacao);
    float recolor_forca = max(mascara_vermelha, mascara_marrom) * nao_preto;
    float detalhe = clamp(brilho * 1.10 + saturacao * 0.20, 0.0, 1.0);
    vec3 cor_escura = u_color.rgb * 0.36;
    vec3 cor_media = u_color.rgb;
    vec3 cor_clara = min(vec3(1.0), u_color.rgb + vec3(0.18, 0.40, 0.18));
    vec3 cor_sombreada = mix(cor_escura, cor_media, smoothstep(0.18, 0.62, detalhe));

    cor_sombreada = mix(cor_sombreada, cor_clara, smoothstep(0.62, 0.95, detalhe));

    vec3 cor_final = mix(original, cor_sombreada, recolor_forca);

    gl_FragColor = vec4(cor_final, tex.a * v_vColour.a * u_color.a);
}
