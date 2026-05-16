var _cx = 30;
var _cy = 30;
var _raio = 20;
var _porcentagem = global.tentativas / global.ui_tentativas;

if (_porcentagem > 0) {
    var _secoes = 32;
    var _angulo_total = 360 * _porcentagem;

    draw_set_color(c_red);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_cx, _cy);

    for (var i = 0; i <= _secoes; i++) {
        var _angulo = -270 + (_angulo_total * (i / _secoes));
        var _vx = _cx + lengthdir_x(_raio, _angulo);
        var _vy = _cy + lengthdir_y(_raio, _angulo);

        draw_vertex(_vx, _vy);
    }

    draw_primitive_end();
}

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_cx, _cy, global.tentativas);

var _progresso_x1 = 75;
var _progresso_x2 = room_width - 65;
var _progresso_y = 27;
var _cor_progresso = make_color_rgb(255, 96, 0);
var _qtd = global.inimigos_por_fase;
var _atual = global.inimigo_atual_fase;

draw_set_color(_cor_progresso);
draw_line_width(_progresso_x1, _progresso_y, _progresso_x2, _progresso_y, 3);

for (var j = 0; j < _qtd; j++) {
    var _t = j / (_qtd - 1);
    var _px = lerp(_progresso_x1, _progresso_x2, _t);
    var _boss = (j == _qtd - 1);
    var _raio_ponto = _boss ? 10 : 4;
    var _passou = (j < _atual);
    var _ativo = (j == _atual);

    draw_set_color(_cor_progresso);
    draw_circle(_px, _progresso_y, _raio_ponto, false);

    if (!_passou && !_ativo) {
        draw_set_color(c_black);
        draw_circle(_px, _progresso_y, max(1, _raio_ponto - 3), false);
    }

    if (_ativo) {
        draw_set_color(c_white);
        draw_circle(_px, _progresso_y, _raio_ponto + 3, true);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
