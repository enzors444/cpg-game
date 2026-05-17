var _texto = montar_texto_expressao(false);
var _top_space = global.ui_top_space;

var _x = room_width / 2;
var _y = 175 + _top_space;
var _w = 300;
var _h = 34;

var _arena_top = 20 + _top_space;
var _arena_bottom = _y - _h / 2 - 12;
var _arena_w = 600;

draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(_x - _arena_w / 2, _arena_top, _x + _arena_w / 2, _arena_bottom, true);

draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(_x - _w / 2, _y - _h / 2, _x + _w / 2, _y + _h / 2, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(_x - _w / 2, _y - _h / 2, _x + _w / 2, _y + _h / 2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _efeito_boss_texto = "";
var _bonus_sem_volta = 0;

if (boss_modificador_ativo() && array_length(global.expressao_partes) > 0) {
    _efeito_boss_texto = boss_modificador_texto_display();

    if (expressao_valida()) {
        _bonus_sem_volta = bonus_sem_volta_valor(boss_modificador_dano(calcular_resultado_expressao()));
    }
} else if (!(boss_exato_ativo() || boss_desafio_ativo())) {
    _bonus_sem_volta = bonus_sem_volta_preview();
}

if (boss_modificador_ativo() && global.boss_estagio == 2 && array_length(global.expressao_partes) > 0) {
    var _bonus_texto_div = " + " + string(_bonus_sem_volta);
    var _texto_parenteses = "(" + _texto + ")";
    var _div_texto = " / 2";
    var _texto_w_div = string_width(_texto_parenteses);
    var _div_w = string_width(_div_texto);
    var _bonus_w_div = (_bonus_sem_volta > 0) ? string_width(_bonus_texto_div) : 0;
    var _total_w_div = _texto_w_div + _div_w + _bonus_w_div;
    var _texto_x_div = _x - _total_w_div / 2;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_texto_x_div, _y, _texto_parenteses);

    draw_set_color(make_color_rgb(255, 70, 70));
    draw_text(_texto_x_div + _texto_w_div, _y, _div_texto);

    if (_bonus_sem_volta > 0) {
        draw_set_color(make_color_rgb(80, 255, 120));
        draw_text(_texto_x_div + _texto_w_div + _div_w, _y, _bonus_texto_div);
    }
} else if (boss_modificador_ativo() && global.boss_estagio == 3 && array_length(global.expressao_partes) > 0) {
    var _bonus_texto_raiz = " + " + string(_bonus_sem_volta);
    var _texto_raiz = "(" + _texto + ")";
    var _texto_w_raiz = string_width(_texto_raiz);
    var _root_w = 24;
    var _bonus_w_raiz = (_bonus_sem_volta > 0) ? string_width(_bonus_texto_raiz) : 0;
    var _total_w_raiz = _root_w + _texto_w_raiz + _bonus_w_raiz;
    var _texto_x_raiz = _x - _total_w_raiz / 2;
    var _root_x = _texto_x_raiz;
    var _root_y = _y;
    var _expr_x = _texto_x_raiz + _root_w;
    var _bar_y = _root_y - 13;
    var _bar_x1 = _expr_x - 2;
    var _bar_x2 = _expr_x + _texto_w_raiz + 4;

    draw_set_color(make_color_rgb(255, 70, 70));
    draw_line_width(_root_x + 2, _root_y + 4, _root_x + 8, _root_y + 12, 3);
    draw_line_width(_root_x + 8, _root_y + 12, _root_x + 15, _bar_y, 3);
    draw_line_width(_root_x + 15, _bar_y, _bar_x1, _bar_y, 3);
    draw_line_width(_bar_x1, _bar_y, _bar_x2, _bar_y, 3);

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_expr_x, _y, _texto_raiz);

    if (_bonus_sem_volta > 0) {
        draw_set_color(make_color_rgb(80, 255, 120));
        draw_text(_expr_x + _texto_w_raiz, _y, _bonus_texto_raiz);
    }
} else if (_efeito_boss_texto != "" || _bonus_sem_volta > 0) {
    var _bonus_texto = " + " + string(_bonus_sem_volta);
    var _texto_w = string_width(_texto);
    var _efeito_w = string_width(_efeito_boss_texto);
    var _bonus_w = string_width(_bonus_texto);
    var _total_w = _texto_w + _efeito_w;

    if (_bonus_sem_volta > 0) {
        _total_w += _bonus_w;
    }

    var _texto_x = _x - _total_w / 2;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_texto_x, _y, _texto);

    if (_efeito_boss_texto != "") {
        draw_set_color(make_color_rgb(255, 70, 70));
        draw_text(_texto_x + _texto_w, _y, _efeito_boss_texto);
    }

    if (_bonus_sem_volta > 0) {
        draw_set_color(make_color_rgb(80, 255, 120));
        draw_text(_texto_x + _texto_w + _efeito_w, _y, _bonus_texto);
    }
} else {
    draw_text(_x, _y, _texto);
}

if (variable_global_exists("boss_ativo") && global.boss_ativo) {
    var _boss_fala = boss_fala_atual();
    var _boss_nome_balao = "";
    var _boss_texto_balao = _boss_fala;
    var _quebra_nome_balao = string_pos("#", _boss_fala);

    if (_quebra_nome_balao > 0) {
        _boss_nome_balao = string_copy(_boss_fala, 1, _quebra_nome_balao - 1);
        _boss_texto_balao = string_delete(_boss_fala, 1, _quebra_nome_balao);
    }

    var _boss_inst = noone;

    for (var _i_boss = 0; _i_boss < instance_number(obj_enemy); _i_boss++) {
        var _enemy_boss = instance_find(obj_enemy, _i_boss);

        if (variable_instance_exists(_enemy_boss, "boss_visual") && _enemy_boss.boss_visual) {
            _boss_inst = _enemy_boss;
            break;
        }
    }

    var _boss_cx = _x + 145;
    var _boss_top = _arena_top + 56;
    var _boss_left = _boss_cx - 36;
    var _boss_right = _boss_cx + 36;
    var _boss_bottom = _arena_bottom;

    if (_boss_inst != noone) {
        var _boss_scale_x = abs(_boss_inst.image_xscale);
        var _boss_scale_y = abs(_boss_inst.image_yscale);
        var _boss_sprite = _boss_inst.sprite_index;
        var _boss_w_real = sprite_get_width(_boss_sprite) * _boss_scale_x;
        var _boss_h_real = sprite_get_height(_boss_sprite) * _boss_scale_y;
        _boss_left = _boss_inst.x - sprite_get_xoffset(_boss_sprite) * _boss_scale_x;
        _boss_top = _boss_inst.y - sprite_get_yoffset(_boss_sprite) * _boss_scale_y;
        _boss_right = _boss_left + _boss_w_real;
        _boss_bottom = _boss_top + _boss_h_real;
        _boss_cx = (_boss_left + _boss_right) / 2;
    }

    var _player_top = _arena_bottom;
    var _player_left = _x - _arena_w / 2;
    var _player_right = _player_left;

    if (instance_exists(obj_player)) {
        var _player_inst = instance_find(obj_player, 0);
        var _player_sprite = _player_inst.sprite_index;
        var _player_scale_x = abs(_player_inst.image_xscale);
        var _player_scale_y = abs(_player_inst.image_yscale);
        var _player_w_real = sprite_get_width(_player_sprite) * _player_scale_x;
        _player_top = _player_inst.y - sprite_get_yoffset(_player_sprite) * _player_scale_y;
        _player_left = _player_inst.x - sprite_get_xoffset(_player_sprite) * _player_scale_x;
        _player_right = _player_left + _player_w_real;
    }

    var _balao_w = 168;
    var _balao_padding = 8;
    var _balao_text_sep = 12;
    var _balao_nome_h = (_boss_nome_balao != "") ? 15 : 0;
    var _arena_left = max(8, _x - _arena_w / 2 + 8);
    var _arena_right = min(room_width - 8, _x + _arena_w / 2 - 8);
    var _margem_personagem = 4;
    var _vao_x1 = _player_right + _margem_personagem;
    var _vao_x2 = _boss_left - _margem_personagem;
    var _vao_w = _vao_x2 - _vao_x1;

    if (_vao_w > 96) {
        _balao_w = clamp(_vao_w, 118, _balao_w);
    }

    var _balao_text_w = _balao_w - _balao_padding * 2;
    var _balao_corpo_h = string_height_ext(_boss_texto_balao, _balao_text_sep, _balao_text_w);
    var _balao_h = max(40, _balao_nome_h + _balao_corpo_h + _balao_padding * 2);
    var _balao_x1 = _vao_x1 + (_vao_w - _balao_w) / 2 + 18;

    if (_vao_w <= 96) {
        _balao_x1 = _boss_left - _margem_personagem - _balao_w;
    }

    _balao_x1 = clamp(_balao_x1, _arena_left, _arena_right - _balao_w);
    var _topo_personagens = min(_boss_top, _player_top);
    var _balao_y1 = _topo_personagens - _balao_h - 6;
    var _balao_y_max = _arena_bottom - _balao_h - 4;

    _balao_y1 = clamp(_balao_y1, _arena_top + 2, _balao_y_max);

    var _balao_x2 = _balao_x1 + _balao_w;
    var _balao_y2 = _balao_y1 + _balao_h;
    var _cauda_ponta_x = clamp(_boss_left + 28, _boss_left + 4, _boss_right - 4);
    var _cauda_x = clamp(_cauda_ponta_x - 8, _balao_x1 + 36, _balao_x2 - 24);
    var _cauda_y = clamp(_boss_top + 24, _balao_y2 + 8, _arena_bottom - 8);
    var _cauda_base_esq = _cauda_x - 12;
    var _cauda_base_dir = _cauda_x + 10;

    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_roundrect(_balao_x1, _balao_y1, _balao_x2, _balao_y2, false);
    draw_triangle(_cauda_base_esq, _balao_y2, _cauda_base_dir, _balao_y2, _cauda_ponta_x, _cauda_y, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_roundrect(_balao_x1, _balao_y1, _balao_x2, _balao_y2, true);
    draw_line_width(_cauda_base_esq, _balao_y2, _cauda_base_dir, _balao_y2, 3);
    draw_line_width(_cauda_base_dir, _balao_y2, _cauda_ponta_x, _cauda_y, 2);
    draw_line_width(_cauda_ponta_x, _cauda_y, _cauda_base_esq, _balao_y2, 2);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    if (_boss_nome_balao != "") {
        draw_set_color(c_yellow);
        draw_text(_balao_x1 + _balao_padding, _balao_y1 + 7, _boss_nome_balao);
    }

    draw_set_color(c_white);
    draw_text_ext(_balao_x1 + _balao_padding, _balao_y1 + _balao_padding + _balao_nome_h, _boss_texto_balao, _balao_text_sep, _balao_text_w);
}

if (variable_global_exists("jogo_vencido") && global.jogo_vencido) {
    var _painel_w = 360;
    var _painel_h = 86;
    var _painel_x = room_width / 2;
    var _painel_y = room_height / 2;

    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_rectangle(_painel_x - _painel_w / 2, _painel_y - _painel_h / 2, _painel_x + _painel_w / 2, _painel_y + _painel_h / 2, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_painel_x - _painel_w / 2, _painel_y - _painel_h / 2, _painel_x + _painel_w / 2, _painel_y + _painel_h / 2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(_painel_x, _painel_y - 14, "Voce venceu");

    draw_set_color(c_white);
    draw_text(_painel_x, _painel_y + 16, "Todos os desafios foram concluidos.");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
