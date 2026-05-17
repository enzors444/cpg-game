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
var _qtd = encontros_combate_da_fase(global.fase);
var _atual = global.inimigo_atual_fase;

global.inimigos_por_fase = _qtd;

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

for (var k = 0; k < _qtd; k++) {
    if (!recompensa_apos_encontro(global.fase, k)) continue;

    var _t_carta = k / max(1, _qtd - 1);
    var _cx_carta = lerp(_progresso_x1, _progresso_x2, _t_carta);

    if (k < _qtd - 1) {
        var _t_proximo = (k + 1) / max(1, _qtd - 1);
        _cx_carta = lerp(_cx_carta, lerp(_progresso_x1, _progresso_x2, _t_proximo), 0.5);
    } else {
        _cx_carta = min(room_width - 35, _cx_carta + 24);
    }

    var _reward_ativo = global.recompensa_roguelike_aberta && _atual == k + 1;
    var _reward_passou = _atual > k;

    draw_set_color(_reward_ativo ? c_yellow : _cor_progresso);
    draw_rectangle(_cx_carta - 5, _progresso_y - 7, _cx_carta + 5, _progresso_y + 7, false);

    if (!_reward_passou && !_reward_ativo) {
        draw_set_color(c_black);
        draw_rectangle(_cx_carta - 2, _progresso_y - 4, _cx_carta + 2, _progresso_y + 4, false);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);

inicializar_roguelike();

var _inv_x = 8;
var _inv_w = 36;
var _inv_h = 42;
var _inv_y = room_height - 30 - _inv_h / 2;
var _inv_cor = make_color_rgb(255, 96, 0);
var _inv_qtd = array_length(global.cartas_roguelike_escolhidas);

if (inventario_aberto) {
    var _painel_w = 178;
    var _linha_h = 42;
    var _painel_h = 42 + max(1, _inv_qtd) * _linha_h;
    var _painel_y = _inv_y - _painel_h - 6;

    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(10, 5, 4));
    draw_rectangle(_inv_x, _painel_y, _inv_x + _painel_w, _inv_y - 6, false);

    draw_set_alpha(1);
    draw_set_color(_inv_cor);
    draw_rectangle(_inv_x, _painel_y, _inv_x + _painel_w, _inv_y - 6, true);

    draw_set_color(c_white);
    draw_text(_inv_x + 8, _painel_y + 8, "Inventario");

    if (_inv_qtd <= 0) {
        draw_set_color(make_color_rgb(180, 180, 180));
        draw_text(_inv_x + 8, _painel_y + 50, "Sem cartas");
    } else {
        for (var i = 0; i < _inv_qtd; i++) {
            var _carta = carta_roguelike(global.cartas_roguelike_escolhidas[i]);
            var _linha_y = _painel_y + 38 + i * _linha_h;

            draw_set_color(make_color_rgb(26, 13, 10));
            draw_rectangle(_inv_x + 6, _linha_y, _inv_x + _painel_w - 6, _linha_y + _linha_h - 5, false);
            draw_set_color(make_color_rgb(92, 48, 22));
            draw_rectangle(_inv_x + 6, _linha_y, _inv_x + _painel_w - 6, _linha_y + _linha_h - 5, true);

            draw_set_color(c_white);
            draw_text(_inv_x + 12, _linha_y + 6, _carta.nome);

            draw_set_color(make_color_rgb(190, 190, 190));
            draw_text_ext(_inv_x + 12, _linha_y + 20, _carta.descricao, 10, _painel_w - 24);
        }
    }
}

draw_set_alpha(0.95);
draw_set_color(make_color_rgb(10, 5, 4));
draw_rectangle(_inv_x, _inv_y, _inv_x + _inv_w, _inv_y + _inv_h, false);

draw_set_alpha(1);
draw_set_color(inventario_aberto ? c_yellow : _inv_cor);
draw_rectangle(_inv_x, _inv_y, _inv_x + _inv_w, _inv_y + _inv_h, true);

draw_set_color(inventario_aberto ? c_yellow : c_white);
draw_rectangle(_inv_x + 8, _inv_y + 10, _inv_x + 24, _inv_y + 24, true);
draw_rectangle(_inv_x + 12, _inv_y + 14, _inv_x + 28, _inv_y + 28, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_inv_x + _inv_w - 8, _inv_y + 10, string(_inv_qtd));

draw_set_halign(fa_left);
draw_set_valign(fa_top);
