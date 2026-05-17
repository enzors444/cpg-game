if (!variable_global_exists("game_over_ativo") || !global.game_over_ativo) {
    exit;
}

var _panel_w = 360;
var _panel_h = 250;
var _panel_x1 = room_width / 2 - _panel_w / 2;
var _panel_y1 = room_height / 2 - _panel_h / 2;
var _panel_x2 = _panel_x1 + _panel_w;
var _panel_y2 = _panel_y1 + _panel_h;
var _input_label = "x =";
var _input_w = 152;
var _input_gap = 10;
var _input_group_w = string_width(_input_label) + _input_gap + _input_w;
var _input_label_x = room_width / 2 - _input_group_w / 2;
var _input_x1 = _input_label_x + string_width(_input_label) + _input_gap;
var _input_y1 = _panel_y1 + 106;
var _input_x2 = _input_x1 + _input_w;
var _input_y2 = _input_y1 + 30;
var _btn_x1 = _panel_x2 - 132;
var _btn_y1 = _panel_y2 - 48;
var _btn_x2 = _btn_x1 + 96;
var _btn_y2 = _btn_y1 + 30;
var _timer_x1 = _panel_x1 + 38;
var _timer_y1 = _input_y2 + 18;
var _timer_x2 = _panel_x2 - 38;
var _timer_y2 = _timer_y1 + 6;
var _tempo = max(0, global.game_over_timer / global.game_over_timer_max);
var _segundos = ceil(max(0, global.game_over_timer) / 60);

draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(10, 4, 4));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_red);
draw_text(room_width / 2, _panel_y1 + 14, "GAME OVER");

draw_set_color(c_white);
draw_text(room_width / 2, _panel_y1 + 42, "Resolva para continuar");

draw_set_color(c_yellow);
draw_text(room_width / 2, _panel_y1 + 70, global.game_over_equacao);

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_rectangle(_input_x1, _input_y1, _input_x2, _input_y2, true);
draw_text(_input_label_x, _input_y1 + 7, _input_label);
draw_text(_input_x1 + 10, _input_y1 + 7, resposta);

draw_set_color(make_color_rgb(90, 90, 90));
draw_rectangle(_timer_x1, _timer_y1, _timer_x2, _timer_y2, false);

draw_set_color(make_color_rgb(255, 70, 70));
draw_rectangle(_timer_x1, _timer_y1, _timer_x1 + (_timer_x2 - _timer_x1) * _tempo, _timer_y2, false);

draw_set_halign(fa_left);
draw_set_color(make_color_rgb(200, 200, 200));
draw_text(_timer_x1, _timer_y2 + 8, "Tempo: " + string(_segundos));

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_rectangle(_btn_x1, _btn_y1, _btn_x2, _btn_y2, true);
draw_text((_btn_x1 + _btn_x2) / 2, _btn_y1 + 7, "OK");

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
