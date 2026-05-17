if (!variable_global_exists("transicao_fase_ativa") || !global.transicao_fase_ativa) {
    exit;
}

var _timer = global.transicao_fase_timer;
var _alpha = min(1, _timer / 28);

draw_set_alpha(_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

if (_timer > 16) {
    var _texto_alpha = min(1, (_timer - 16) / 24);

    draw_set_alpha(_texto_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(room_width / 2, room_height / 2 - 12, global.transicao_fase_titulo);

    draw_set_color(c_white);
    draw_text(room_width / 2, room_height / 2 + 20, global.transicao_fase_subtitulo);
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
