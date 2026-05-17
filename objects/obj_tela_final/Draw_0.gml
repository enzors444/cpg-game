draw_set_alpha(1);
draw_set_color(make_color_rgb(7, 5, 10));
draw_rectangle(0, 0, room_width, room_height, false);

var _sprite_w = sprite_get_width(tela_final_sprite);
var _sprite_h = sprite_get_height(tela_final_sprite);
var _sprite_scale = max(room_width / _sprite_w, room_height / _sprite_h);

var _sprite_x = room_width / 2 - _sprite_w * _sprite_scale / 2;
var _sprite_y = room_height / 2 - _sprite_h * _sprite_scale / 2;
draw_sprite_ext(tela_final_sprite, 0, _sprite_x, _sprite_y, _sprite_scale, _sprite_scale, 0, c_white, 1);

draw_set_alpha(0.28);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, 128, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _titulo_cor = tela_final_tipo == "vitoria" ? make_color_rgb(153, 229, 80) : c_red;
var _titulo_sombra = tela_final_tipo == "vitoria" ? make_color_rgb(25, 80, 35) : make_color_rgb(80, 0, 0);

draw_set_color(_titulo_sombra);
draw_text_transformed(room_width / 2 + 4, 70 + 4, tela_final_titulo, 4, 4, 0);
draw_set_color(_titulo_cor);
draw_text_transformed(room_width / 2, 70, tela_final_titulo, 4, 4, 0);

if (tela_final_subtitulo != "") {
    draw_set_color(c_black);
    draw_text_transformed(room_width / 2 + 3, room_height - 152 + 3, tela_final_subtitulo, 2, 2, 0);
    draw_set_color(c_white);
    draw_text_transformed(room_width / 2, room_height - 152, tela_final_subtitulo, 2, 2, 0);
}

var _qtd = array_length(tela_final_botoes);
var _botao_w = 230;
var _botao_h = 62;
var _margem_botao = 24;
var _y1 = room_height - 94;

for (var i = 0; i < _qtd; i++) {
    var _x1 = room_width / 2 - _botao_w / 2;

    if (_qtd > 1) {
        _x1 = (i == 0) ? _margem_botao : room_width - _margem_botao - _botao_w;
    }

    var _x2 = _x1 + _botao_w;
    var _y2 = _y1 + _botao_h;
    var _hover = tela_final_hover == i;

    draw_set_color(_hover ? make_color_rgb(190, 255, 112) : make_color_rgb(153, 229, 80));
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    draw_set_color(make_color_rgb(30, 15, 46));
    draw_rectangle(_x1 + 6, _y1 + 6, _x2 - 6, _y2 - 6, false);

    draw_set_color(_hover ? make_color_rgb(255, 245, 170) : c_white);
    draw_rectangle(_x1, _y1, _x2, _y2, true);

    draw_set_color(c_black);
    draw_text_transformed((_x1 + _x2) / 2 + 2, (_y1 + _y2) / 2 + 2, tela_final_botoes[i].texto, 2, 2, 0);
    draw_set_color(_hover ? make_color_rgb(255, 245, 170) : c_white);
    draw_text_transformed((_x1 + _x2) / 2, (_y1 + _y2) / 2, tela_final_botoes[i].texto, 2, 2, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
