draw_set_alpha(1);
draw_set_color(make_color_rgb(38, 35, 33));
draw_rectangle(0, 0, room_width, room_height, false);

var _menu_w = sprite_get_width(spr_menu);
var _menu_h = sprite_get_height(spr_menu);
var _menu_scale = max(room_width / _menu_w, room_height / _menu_h);
var _menu_x = room_width / 2 - (_menu_w * _menu_scale) / 2;
var _menu_y = room_height / 2 - (_menu_h * _menu_scale) / 2;

if (menu_tela == "creditos") {
    draw_sprite_ext(spr_creditos, 0, _menu_x, _menu_y, _menu_scale, _menu_scale, 0, c_white, 1);

    var _voltar_x1 = _menu_x + 24 * _menu_scale;
    var _voltar_y1 = _menu_y + 276 * _menu_scale;
    var _voltar_x2 = _voltar_x1 + 92 * _menu_scale;
    var _voltar_y2 = _voltar_y1 + 28 * _menu_scale;
    var _voltar_hover = point_in_rectangle(mouse_x, mouse_y, _voltar_x1, _voltar_y1, _voltar_x2, _voltar_y2);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_voltar_hover ? make_color_rgb(190, 255, 112) : make_color_rgb(153, 229, 80));
    draw_rectangle(_voltar_x1, _voltar_y1, _voltar_x2, _voltar_y2, false);

    draw_set_color(make_color_rgb(30, 15, 46));
    draw_rectangle(_voltar_x1 + 3, _voltar_y1 + 3, _voltar_x2 - 3, _voltar_y2 - 3, false);

    draw_set_color(_voltar_hover ? make_color_rgb(255, 245, 170) : c_white);
    draw_rectangle(_voltar_x1, _voltar_y1, _voltar_x2, _voltar_y2, true);
    draw_text((_voltar_x1 + _voltar_x2) / 2, (_voltar_y1 + _voltar_y2) / 2, "VOLTAR");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    exit;
}

draw_sprite_ext(spr_menu, 0, _menu_x, _menu_y, _menu_scale, _menu_scale, 0, c_white, 1);

var _player_frame = floor(menu_anim_player) mod sprite_get_number(spr_player_idle);
draw_sprite_ext(
    spr_player_idle,
    _player_frame,
    _menu_x + menu_player_x * _menu_scale,
    _menu_y + menu_player_y * _menu_scale,
    menu_player_escala * _menu_scale,
    menu_player_escala * _menu_scale,
    0,
    c_white,
    1
);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = 0; i < array_length(menu_botoes); i++) {
    var _botao = menu_botoes[i];
    var _x1 = _menu_x + _botao.rx * _menu_scale;
    var _y1 = _menu_y + _botao.ry * _menu_scale;
    var _x2 = _x1 + _botao.w * _menu_scale;
    var _y2 = _y1 + _botao.h * _menu_scale;
    var _hover = menu_hover == i;

    draw_set_color(_hover ? make_color_rgb(190, 255, 112) : make_color_rgb(153, 229, 80));
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    draw_set_color(make_color_rgb(30, 15, 46));
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, false);

    draw_set_color(_hover ? make_color_rgb(255, 245, 170) : c_white);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_text((_x1 + _x2) / 2, (_y1 + _y2) / 2, _botao.texto);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
