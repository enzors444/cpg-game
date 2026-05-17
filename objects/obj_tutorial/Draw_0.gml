draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

var _top_space = 50;
var _x = room_width / 2;
var _texto_y = 175 + _top_space;
var _texto_h = 34;
var _arena_top = 20 + _top_space;
var _arena_bottom = _texto_y - _texto_h / 2 - 12;
var _arena_w = 600;
var _arena_x1 = _x - _arena_w / 2;
var _arena_x2 = _x + _arena_w / 2;
var _arena_h = _arena_bottom - _arena_top;

draw_set_color(make_color_rgb(18, 5, 4));
draw_rectangle(_arena_x1, _arena_top, _arena_x2, _arena_bottom, false);

var _bg_sprite = spr_arena_room1;
var _bg_w = sprite_get_width(_bg_sprite);
var _bg_h = sprite_get_height(_bg_sprite);

if (_bg_w > 0 && _bg_h > 0 && _arena_h > 0) {
    var _scale_x = max(1, _arena_h / _bg_h);
    var _scale_y = _arena_h / _bg_h;
    var _tile_w = _bg_w * _scale_x;
    var _offset = scroll_cenario mod _tile_w;

    for (var _tile_x = _arena_x1 - _offset; _tile_x < _arena_x2; _tile_x += _tile_w) {
        var _draw_x1 = max(_tile_x, _arena_x1);
        var _draw_x2 = min(_tile_x + _tile_w, _arena_x2);
        var _draw_w = _draw_x2 - _draw_x1;

        if (_draw_w <= 0) continue;

        var _src_x = (_draw_x1 - _tile_x) / _scale_x;
        var _src_w = _draw_w / _scale_x;

        draw_sprite_part_ext(
            _bg_sprite,
            0,
            _src_x,
            0,
            _src_w,
            _bg_h,
            _draw_x1,
            _arena_top,
            _scale_x,
            _scale_y,
            c_white,
            1
        );
    }
}

var _frame_player = floor(anim_player) mod sprite_get_number(spr_player_walking);
var _frame_professor = floor(anim_professor) mod sprite_get_number(spr_mosca);

draw_sprite_ext(spr_player_walking, _frame_player, room_width / 3, 110 + _top_space, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_mosca, _frame_professor, 325, 92, 1.5, 1.5, 0, c_white, 1);

var _caixa_y1 = 238;
var _caixa_y2 = room_height - 24;
var _caixa_margem_tela = 2;
var _caixa_x1 = max(_caixa_margem_tela, _arena_x1);
var _caixa_x2 = min(room_width - _caixa_margem_tela, _arena_x2);
var _ok_w = 64;
var _ok_h = 28;
var _ok_x1 = _caixa_x2 - 84;
var _ok_y1 = _caixa_y2 - 40;
var _ok_x2 = _ok_x1 + _ok_w;
var _ok_y2 = _ok_y1 + _ok_h;
var _texto_x = _caixa_x1 + 18;
var _texto_y_interno = _caixa_y1 + 18;
var _texto_largura = max(120, _caixa_x2 - _texto_x - 24);

draw_set_alpha(0.88);
draw_set_color(c_black);
draw_rectangle(_caixa_x1, _caixa_y1, _caixa_x2, _caixa_y2, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(_caixa_x1, _caixa_y1, _caixa_x2, _caixa_y2, true);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
var _dialogo_indice = min(dialogo_atual, array_length(dialogos) - 1);
var _texto_completo = dialogos[_dialogo_indice];
var _texto_mostrado = string_copy(_texto_completo, 1, min(string_length(_texto_completo), texto_revelado));
_texto_mostrado = string_replace_all(_texto_mostrado, "#", chr(10));
draw_text_ext(_texto_x, _texto_y_interno, _texto_mostrado, 15, _texto_largura);

var _hover_ok = point_in_rectangle(mouse_x, mouse_y, _ok_x1, _ok_y1, _ok_x2, _ok_y2);

draw_set_color(_hover_ok ? make_color_rgb(255, 230, 90) : c_white);
draw_rectangle(_ok_x1, _ok_y1, _ok_x2, _ok_y2, true);

draw_set_color(c_black);
draw_rectangle(_ok_x1 + 2, _ok_y1 + 2, _ok_x2 - 2, _ok_y2 - 2, false);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text((_ok_x1 + _ok_x2) / 2, (_ok_y1 + _ok_y2) / 2, "OK");

draw_set_color(make_color_rgb(180, 180, 180));
draw_text(_ok_x1 - 30, _ok_y1 + _ok_h / 2, string(_dialogo_indice + 1) + "/" + string(array_length(dialogos)));

if (transicao) {
    var _alpha = min(1, transicao_timer / 35);

    draw_set_alpha(_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);

    if (transicao_timer > 18) {
        draw_set_alpha(min(1, (transicao_timer - 18) / 22));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text(room_width / 2, room_height / 2 - 8, "Fase 1");

        draw_set_color(c_white);
        draw_text(room_width / 2, room_height / 2 + 22, "A primeira sala comeca agora.");
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
