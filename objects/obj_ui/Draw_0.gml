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
var _progresso_visual = _atual;
var _andando_arena = variable_global_exists("em_caminhada_arena") && global.em_caminhada_arena;

if (variable_global_exists("progresso_visual")) {
    _progresso_visual = clamp(global.progresso_visual, 0, _qtd - 1);
}

global.inimigos_por_fase = _qtd;

draw_set_color(_cor_progresso);
draw_line_width(_progresso_x1, _progresso_y, _progresso_x2, _progresso_y, 3);

for (var j = 0; j < _qtd; j++) {
    var _t = j / (_qtd - 1);
    var _px = lerp(_progresso_x1, _progresso_x2, _t);
    var _boss = (j == _qtd - 1);
    var _raio_ponto = _boss ? 10 : 4;
    var _passou = (j < _progresso_visual);
    var _ativo = (!_andando_arena && j == _atual);

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

var _t_marcador = _progresso_visual / max(1, _qtd - 1);
var _px_marcador = lerp(_progresso_x1, _progresso_x2, _t_marcador);

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
    var _reward_passou = _progresso_visual > k;

    draw_set_color(_reward_ativo ? c_yellow : _cor_progresso);
    draw_rectangle(_cx_carta - 5, _progresso_y - 7, _cx_carta + 5, _progresso_y + 7, false);

    if (!_reward_passou && !_reward_ativo) {
        draw_set_color(c_black);
        draw_rectangle(_cx_carta - 2, _progresso_y - 4, _cx_carta + 2, _progresso_y + 4, false);
    }
}

draw_set_color(c_white);
draw_circle(_px_marcador, _progresso_y, 8, true);
draw_set_color(_cor_progresso);
draw_circle(_px_marcador, _progresso_y, 4, false);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

inicializar_roguelike();

var _inv_w = 48;
var _inv_h = 48;
var _inv_x = 8;
var _inv_y = room_height - 30 - _inv_h / 2;
var _inv_draw_y = _inv_y + inventario_y_offset;
var _inv_cx = _inv_x + _inv_w / 2;
var _inv_cy = _inv_draw_y + _inv_h / 2;
var _inv_qtd = array_length(global.cartas_roguelike_escolhidas);
var _inv_frame = max(0, sprite_get_number(spr_operations) - 1);
var _card_w = 48;
var _card_h = 64;
var _card_gap = 8;

if (inventario_aberto) {
    for (var i = 0; i < _inv_qtd; i++) {
        var _card_x1 = _inv_cx - _card_w / 2;
        var _card_y2 = _inv_draw_y - _card_gap - i * (_card_h + _card_gap);
        var _card_y1 = _card_y2 - _card_h;
        var _card_x2 = _inv_cx + _card_w / 2;

        draw_set_alpha(0.95);
        draw_set_color(make_color_rgb(70, 8, 4));
        draw_rectangle(_card_x1, _card_y1, _card_x2, _card_y2, false);

        draw_set_alpha(1);
        draw_set_color(make_color_rgb(235, 24, 18));
        draw_rectangle(_card_x1, _card_y1, _card_x2, _card_y2, true);

        draw_set_color(make_color_rgb(120, 16, 8));
        draw_rectangle(_card_x1 + 4, _card_y2 - 12, _card_x2 - 4, _card_y2 - 4, false);
    }
}

draw_set_alpha(0.95);
draw_set_color(inventario_hover ? make_color_rgb(24, 15, 14) : make_color_rgb(10, 5, 4));
draw_rectangle(_inv_x, _inv_draw_y, _inv_x + _inv_w, _inv_draw_y + _inv_h, false);

draw_set_alpha(1);
draw_sprite_ext(spr_operations, _inv_frame, _inv_cx - 24, _inv_cy - 24, 0.75, 0.75, 0, c_white, 1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
