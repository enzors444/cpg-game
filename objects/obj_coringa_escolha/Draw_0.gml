draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(70, 120, room_width - 70, 255, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(room_width / 2, 140, "Valor do coringa");

var _cols = 5;
var _tam = 32;
var _gap = 8;
var _total_w = _cols * _tam + (_cols - 1) * _gap;
var _start_x = room_width / 2 - _total_w / 2;
var _start_y = 160;

for (var n = 0; n <= 9; n++) {
    var _col = n mod _cols;
    var _row = floor(n / _cols);
    var _x = _start_x + _col * (_tam + _gap);
    var _y = _start_y + _row * (_tam + _gap);
    var _hover = point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + _tam, _y + _tam);

    draw_set_color(_hover ? c_yellow : c_white);
    draw_rectangle(_x, _y, _x + _tam, _y + _tam, false);
    draw_set_color(c_black);
    draw_text(_x + _tam / 2, _y + _tam / 2, string(n));
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
