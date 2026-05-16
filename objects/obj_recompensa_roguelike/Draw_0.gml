draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

var _panel_x1 = 26;
var _panel_y1 = 44;
var _panel_x2 = room_width - 26;
var _panel_y2 = room_height - 34;

draw_set_color(make_color_rgb(12, 5, 5));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);
draw_set_color(c_white);
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(room_width / 2, _panel_y1 + 12, "Escolha uma carta");

var _w = 142;
var _h = 198;
var _gap = 8;
var _qtd = array_length(global.roguelike_opcoes);
var _total_w = _qtd * _w + max(0, _qtd - 1) * _gap;
var _start_x = room_width / 2 - _total_w / 2;
var _y = 92;

for (var i = 0; i < _qtd; i++) {
    var _x = _start_x + i * (_w + _gap);
    var _carta = carta_roguelike(global.roguelike_opcoes[i]);
    var _hover = point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + _w, _y + _h);

    draw_set_color(_hover ? make_color_rgb(45, 28, 14) : make_color_rgb(20, 12, 10));
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);

    draw_set_color(_hover ? c_yellow : c_white);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);

    draw_set_color(_hover ? c_yellow : make_color_rgb(110, 64, 34));
    draw_rectangle(_x + 7, _y + 7, _x + _w - 7, _y + _h - 7, true);
    draw_line(_x + 10, _y + 64, _x + _w - 10, _y + 64);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext(_x + _w / 2, _y + 18, _carta.nome, 14, _w - 24);

    draw_set_halign(fa_left);
    draw_text_ext(_x + 14, _y + 84, _carta.descricao, 14, _w - 28);

    draw_set_halign(fa_center);
    draw_set_color(_hover ? c_yellow : make_color_rgb(180, 180, 180));
    draw_text(_x + _w / 2, _y + _h - 30, "ESCOLHER");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
