var _texto = montar_texto_expressao(false);
var _tem_expressao = array_length(global.expressao_partes) > 0;
var _mostra_fala_boss = variable_global_exists("boss_ativo") && global.boss_ativo && !_tem_expressao;
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

if (_mostra_fala_boss) {
    var _fala_completa = boss_fala_atual();

    if (variable_global_exists("boss_display_stream_texto")) {
        _fala_completa = global.boss_display_stream_texto;
    }

    var _chars = string_length(_fala_completa);

    if (variable_global_exists("boss_display_stream_pos")) {
        _chars = floor(global.boss_display_stream_pos);
    }

    var _texto_display = string_copy(_fala_completa, 1, clamp(_chars, 0, string_length(_fala_completa)));
    _texto_display = string_replace(_texto_display, "#", ": ");

    var _conteudo_w = _w - 18;
    var _escala_fala = 0.75;
    var _texto_visivel = _texto_display;

    while (string_width(_texto_visivel) * _escala_fala > _conteudo_w && string_length(_texto_visivel) > 0) {
        _texto_visivel = string_delete(_texto_visivel, 1, 1);
    }

    var _linha_h = string_height("A") * _escala_fala;
    var _texto_x_display = _x - _w / 2 + 9;
    var _texto_y_display = _y - _linha_h / 2;
    var _separador = string_pos(": ", _texto_visivel);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    if (_separador > 0) {
        var _nome_display = string_copy(_texto_visivel, 1, _separador - 1);
        var _fala_display = string_delete(_texto_visivel, 1, _separador - 1);
        var _nome_w = string_width(_nome_display) * _escala_fala;

        draw_set_color(c_yellow);
        draw_text_transformed(_texto_x_display, _texto_y_display, _nome_display, _escala_fala, _escala_fala, 0);

        draw_set_color(c_white);
        draw_text_transformed(_texto_x_display + _nome_w, _texto_y_display, _fala_display, _escala_fala, _escala_fala, 0);
    } else {
        draw_set_color(c_yellow);
        draw_text_transformed(_texto_x_display, _texto_y_display, _texto_visivel, _escala_fala, _escala_fala, 0);
    }
} else {
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
    var _mult_texto_raiz = "2* ";
    var _texto_raiz = "(" + _texto + ")";
    var _mult_w_raiz = string_width(_mult_texto_raiz);
    var _texto_w_raiz = string_width(_texto_raiz);
    var _root_w = 24;
    var _bonus_w_raiz = (_bonus_sem_volta > 0) ? string_width(_bonus_texto_raiz) : 0;
    var _total_w_raiz = _mult_w_raiz + _root_w + _texto_w_raiz + _bonus_w_raiz;
    var _texto_x_raiz = _x - _total_w_raiz / 2;
    var _root_x = _texto_x_raiz + _mult_w_raiz;
    var _root_y = _y;
    var _expr_x = _root_x + _root_w;
    var _bar_y = _root_y - 13;
    var _bar_x1 = _expr_x - 2;
    var _bar_x2 = _expr_x + _texto_w_raiz + 4;

    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(255, 70, 70));
    draw_text(_texto_x_raiz, _y, _mult_texto_raiz);
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
