draw_set_alpha(0.58);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

var _panel_w = 225;
var _panel_h = 170;
var _panel_x = room_width / 2;
var _panel_y = room_height / 2;
var _panel_x1 = _panel_x - _panel_w / 2;
var _panel_y1 = _panel_y - _panel_h / 2;
var _panel_x2 = _panel_x + _panel_w / 2;
var _panel_y2 = _panel_y + _panel_h / 2;

draw_set_alpha(1);
draw_set_color(make_color_rgb(30, 15, 46));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);

draw_set_alpha(1);
draw_set_color(make_color_rgb(153, 229, 80));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_panel_x, _panel_y1 + 30, "PAUSADO");

var _btn_w = 165;
var _btn_h = 28;
var _gap = 10;
var _start_y = _panel_y1 + 64;

for (var i = 0; i < array_length(pause_botoes); i++) {
    var _x1 = room_width / 2 - _btn_w / 2;
    var _y1 = _start_y + i * (_btn_h + _gap);
    var _x2 = _x1 + _btn_w;
    var _y2 = _y1 + _btn_h;
    var _hover = pause_hover == i;

    draw_set_color(_hover ? make_color_rgb(190, 255, 112) : make_color_rgb(153, 229, 80));
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    draw_set_color(make_color_rgb(30, 15, 46));
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, false);

    draw_set_color(_hover ? make_color_rgb(255, 245, 170) : c_white);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_text((_x1 + _x2) / 2, (_y1 + _y2) / 2, pause_botoes[i].texto);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
