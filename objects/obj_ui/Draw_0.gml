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
var _progresso_inicio = -0.45;
var _andando_arena = variable_global_exists("em_caminhada_arena") && global.em_caminhada_arena;

if (variable_global_exists("progresso_inicio_barra")) {
    _progresso_inicio = global.progresso_inicio_barra;
}

if (variable_global_exists("progresso_visual")) {
    _progresso_visual = clamp(global.progresso_visual, _progresso_inicio, _qtd - 1);
}

var _progresso_span = max(1, (_qtd - 1) - _progresso_inicio);
var _tooltip_titulo = "";
var _tooltip_descricao = "";

global.inimigos_por_fase = _qtd;

draw_set_color(_cor_progresso);
draw_line_width(_progresso_x1, _progresso_y, _progresso_x2, _progresso_y, 3);

for (var j = 0; j < _qtd; j++) {
    var _t = (j - _progresso_inicio) / _progresso_span;
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

    if (_tooltip_titulo == "" && point_distance(mouse_x, mouse_y, _px, _progresso_y) <= max(10, _raio_ponto + 4)) {
        if (_boss) {
            _tooltip_titulo = "Boss da sala";

            if (global.fase == 1) {
                _tooltip_descricao = "O Cofre Exato. So toma dano com resultado exato.";
            } else {
                _tooltip_descricao = "Combate final desta sala.";
            }
        } else {
            _tooltip_titulo = "Combate " + string(j + 1);

            if (j < _progresso_visual) {
                _tooltip_descricao = "Inimigo ja derrotado.";
            } else if (_ativo) {
                _tooltip_descricao = "Combate atual.";
            } else {
                _tooltip_descricao = "Um novo inimigo aparece aqui.";
            }
        }
    }
}

var _t_marcador = (_progresso_visual - _progresso_inicio) / _progresso_span;
var _px_marcador = lerp(_progresso_x1, _progresso_x2, _t_marcador);

for (var k = 0; k < _qtd; k++) {
    if (!recompensa_apos_encontro(global.fase, k)) continue;

    var _t_carta = (k - _progresso_inicio) / _progresso_span;
    var _cx_carta = lerp(_progresso_x1, _progresso_x2, _t_carta);

    if (k < _qtd - 1) {
        var _t_proximo = ((k + 1) - _progresso_inicio) / _progresso_span;
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

    if (_tooltip_titulo == "" && point_in_rectangle(mouse_x, mouse_y, _cx_carta - 10, _progresso_y - 12, _cx_carta + 10, _progresso_y + 12)) {
        _tooltip_titulo = "Compra de carta";

        if (_reward_ativo) {
            _tooltip_descricao = "Escolha uma das cartas agora.";
        } else if (k >= _qtd - 1) {
            _tooltip_descricao = "Escolha uma carta antes da proxima sala.";
        } else {
            _tooltip_descricao = "Escolha uma carta antes do proximo inimigo.";
        }
    }
}

draw_set_color(c_white);
draw_circle(_px_marcador, _progresso_y, 8, true);
draw_set_color(_cor_progresso);
draw_circle(_px_marcador, _progresso_y, 4, false);

if (_tooltip_titulo != "") {
    var _tip_w = 196;
    var _tip_h = 50;
    var _tip_x = clamp(mouse_x + 10, 4, room_width - _tip_w - 4);
    var _tip_y = clamp(mouse_y + 12, 4, room_height - _tip_h - 4);

    draw_set_alpha(0.94);
    draw_set_color(c_black);
    draw_rectangle(_tip_x, _tip_y, _tip_x + _tip_w, _tip_y + _tip_h, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_tip_x, _tip_y, _tip_x + _tip_w, _tip_y + _tip_h, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(255, 230, 90));
    draw_text(_tip_x + 6, _tip_y + 5, _tooltip_titulo);
    draw_set_color(make_color_rgb(215, 215, 215));
    draw_text_ext(_tip_x + 6, _tip_y + 20, _tooltip_descricao, 11, _tip_w - 12);
}

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
