var _texto = montar_texto_expressao(false);
var _top_space = global.ui_top_space;

var _x = room_width / 2;
var _y = 175 + _top_space;
var _w = 300;
var _h = 34;

var _arena_top = 20 + _top_space;
var _arena_bottom = _y - _h / 2 - 12;
var _arena_w = 380;

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
draw_text(_x, _y, _texto);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
