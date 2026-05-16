draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(room_width / 2, 72, "Escolha uma carta");

var _w = 130;
var _h = 190;
var _gap = 15;
var _qtd = array_length(global.roguelike_opcoes);
var _total_w = _qtd * _w + max(0, _qtd - 1) * _gap;
var _start_x = room_width / 2 - _total_w / 2;
var _y = 105;

for (var i = 0; i < _qtd; i++) {
    var _x = _start_x + i * (_w + _gap);
    var _carta = carta_roguelike(global.roguelike_opcoes[i]);
    var _hover = point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + _w, _y + _h);

    draw_set_color(_hover ? make_color_rgb(40, 34, 24) : make_color_rgb(18, 12, 10));
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);

    draw_set_color(_hover ? c_yellow : c_white);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext(_x + _w / 2, _y + 18, _carta.nome, 16, _w - 16);

    draw_set_halign(fa_left);
    draw_text_ext(_x + 10, _y + 68, _carta.descricao, 14, _w - 20);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
