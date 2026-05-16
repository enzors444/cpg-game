draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_transformed(room_width / 2, 22, "Escolha uma carta", 0.8, 0.8, 0);

var _w = 150;
var _h = 205;
var _gap = 10;
var _qtd = array_length(global.roguelike_opcoes);
var _total_w = _qtd * _w + max(0, _qtd - 1) * _gap;
var _start_x = room_width / 2 - _total_w / 2;
var _y = 76;

for (var i = 0; i < _qtd; i++) {
    var _x = _start_x + i * (_w + _gap);
    var _carta = carta_roguelike(global.roguelike_opcoes[i]);
    var _hover = point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + _w, _y + _h);

    draw_set_color(_hover ? make_color_rgb(38, 28, 18) : make_color_rgb(18, 12, 10));
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);

    draw_set_color(_hover ? c_yellow : c_white);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext_transformed(_x + _w / 2, _y + 16, _carta.nome, 14, (_w - 18) / 0.62, 0.62, 0.62, 0);

    draw_set_halign(fa_left);
    draw_text_ext_transformed(_x + 10, _y + 78, _carta.descricao, 15, (_w - 20) / 0.55, 0.55, 0.55, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
