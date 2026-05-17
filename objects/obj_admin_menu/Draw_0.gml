draw_set_alpha(0.62);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

var _panel_w = 336;
var _panel_h = 250;
var _panel_x = room_width / 2;
var _panel_y = room_height / 2;
var _panel_x1 = _panel_x - _panel_w / 2;
var _panel_y1 = _panel_y - _panel_h / 2;
var _panel_x2 = _panel_x + _panel_w / 2;
var _panel_y2 = _panel_y + _panel_h / 2;

draw_set_alpha(1);
draw_set_color(make_color_rgb(10, 8, 18));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);

draw_set_color(make_color_rgb(255, 230, 90));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_panel_x, _panel_y1 + 24, "MENU ADMIN");

draw_set_color(make_color_rgb(170, 170, 170));
draw_text(_panel_x, _panel_y1 + 43, "CTRL+SHIFT+A");

var _btn_w = 132;
var _btn_h = 28;
var _gap_x = 12;
var _gap_y = 9;
var _grid_x = room_width / 2 - (_btn_w * 2 + _gap_x) / 2;
var _start_y = _panel_y1 + 58;

for (var i = 0; i < array_length(admin_botoes); i++) {
    var _botao = admin_botoes[i];
    var _full = _botao.acao == "comprar" || _botao.acao == "fechar";
    var _x1 = _full ? room_width / 2 - (_btn_w * 2 + _gap_x) / 2 : _grid_x + _botao.coluna * (_btn_w + _gap_x);
    var _y1 = _start_y + _botao.linha * (_btn_h + _gap_y);
    var _x2 = _full ? room_width / 2 + (_btn_w * 2 + _gap_x) / 2 : _x1 + _btn_w;
    var _y2 = _y1 + _btn_h;
    var _hover = admin_hover == i;
    var _botao_cor = _botao.acao == "comprar" ? make_color_rgb(40, 100, 60) : make_color_rgb(28, 18, 48);

    if (_botao.acao == "fechar") {
        _botao_cor = make_color_rgb(75, 32, 32);
    }

    draw_set_color(_hover ? make_color_rgb(255, 230, 90) : c_white);
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    draw_set_color(_botao_cor);
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, false);

    draw_set_color(_hover ? make_color_rgb(255, 245, 170) : c_white);
    draw_text((_x1 + _x2) / 2, (_y1 + _y2) / 2, _botao.texto);
}

if (admin_feedback_timer > 0 && admin_feedback != "") {
    draw_set_color(make_color_rgb(120, 255, 150));
    draw_text(_panel_x, _panel_y2 - 12, admin_feedback);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
