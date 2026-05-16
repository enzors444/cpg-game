// 1. Configurações do círculo (ajuste o X, Y e o Raio como preferir)
var _cx = 30;  // Posição X (no centro da tela neste exemplo)
var _cy = 30;             // Posição Y 
var _raio = 20;            // Tamanho do círculo
var _porcentagem = global.tentativas / global.ui_tentativas; 

// 3. Só desenha se ainda houver alguma tentativa
if (_porcentagem > 0) {
    var _secoes = 32; // Quanto maior, mais liso/redondo fica o círculo
    var _angulo_total = 360 * _porcentagem;
    
    draw_set_color(c_red); // Cor do círculo (mude para a que quiser)
    
    // Começa a desenhar a forma geométrica (triângulos que formam o círculo)
    draw_primitive_begin(pr_trianglefan);
    
    // Centro do círculo
    draw_vertex(_cx, _cy);
    
    // Desenha as fatias baseadas na porcentagem atual
    for (var i = 0; i <= _secoes; i++) {
        // -90 faz o círculo começar a sumir pelo topo (como um relógio)
        var _angulo = -270 + (_angulo_total * (i / _secoes)); 
        
        var _vx = _cx + lengthdir_x(_raio, _angulo);
        var _vy = _cy + lengthdir_y(_raio, _angulo);
        
        draw_vertex(_vx, _vy);
    }
    
    draw_primitive_end();
}

draw_set_colour(c_white);
draw_text(30,30,global.tentativas);