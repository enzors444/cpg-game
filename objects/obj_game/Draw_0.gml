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

var _bonus_sem_volta = (boss_exato_ativo() || boss_desafio_ativo()) ? 0 : bonus_sem_volta_preview();

if (_bonus_sem_volta > 0) {
    var _bonus_texto = " + " + string(_bonus_sem_volta);
    var _texto_w = string_width(_texto);
    var _bonus_w = string_width(_bonus_texto);
    var _texto_x = _x - (_texto_w + _bonus_w) / 2;

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(_texto_x, _y, _texto);

    draw_set_color(make_color_rgb(80, 255, 120));
    draw_text(_texto_x + _texto_w, _y, _bonus_texto);
} else {
    draw_text(_x, _y, _texto);
}

if (boss_exato_ativo()) {
    var _boss_y = _arena_top + 8;
    var _alvo_texto = global.boss_alvo_oculto ? "??" : string(global.boss_alvo);
    var _linha_alvo = boss_exato_nome_estagio() + " | Alvo: " + _alvo_texto;

    if (global.boss_estagio == 3) {
        _linha_alvo = global.boss_funcao_texto + " | Alvo: " + _alvo_texto;
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(_x, _boss_y, global.boss_nome + " - Estagio " + string(global.boss_estagio) + "/3");

    draw_set_color(c_white);
    draw_text(_x, _boss_y + 14, _linha_alvo);

    draw_set_color(make_color_rgb(220, 220, 220));
    draw_text(_x, _boss_y + 28, global.boss_regra_texto);

    if (global.boss_mensagem != "") {
        draw_set_color(make_color_rgb(180, 220, 255));
        draw_text(_x, _boss_y + 42, global.boss_mensagem);
    }
}

if (boss_desafio_ativo()) {
    var _boss_desafio_y = _arena_top + 8;

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(_x, _boss_desafio_y, global.boss_nome + " - Desafio " + string(global.boss_estagio) + "/3");

    draw_set_color(c_white);
    draw_text(_x, _boss_desafio_y + 14, boss_desafio_nome_estagio());

    draw_set_color(make_color_rgb(220, 220, 220));
    draw_text(_x, _boss_desafio_y + 28, global.boss_desafio_texto);

    if (global.boss_mensagem != "") {
        draw_set_color(make_color_rgb(180, 220, 255));
        draw_text(_x, _boss_desafio_y + 42, global.boss_mensagem);
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
