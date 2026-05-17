var _top_space = global.ui_top_space;
var _x = room_width / 2;
var _texto_y = 175 + _top_space;
var _texto_h = 34;
var _arena_top = 20 + _top_space;
var _arena_bottom = _texto_y - _texto_h / 2 - 12;
var _arena_w = 600;
var _arena_x1 = _x - _arena_w / 2;
var _arena_x2 = _x + _arena_w / 2;
var _arena_h = _arena_bottom - _arena_top;

draw_set_alpha(1);
draw_set_color(make_color_rgb(18, 5, 4));
draw_rectangle(_arena_x1, _arena_top, _arena_x2, _arena_bottom, false);

var _arena_sprite = sprite_arena_da_fase(global.fase);
var _bg_w = sprite_get_width(_arena_sprite);
var _bg_h = sprite_get_height(_arena_sprite);

if (_bg_w > 0 && _bg_h > 0 && _arena_h > 0) {
    var _scale_x = max(1, _arena_h / _bg_h);
    var _scale_y = _arena_h / _bg_h;
    var _tile_w = _bg_w * _scale_x;
    var _scroll = 0;

    if (variable_global_exists("arena_scroll")) {
        _scroll = global.arena_scroll;
    }

    var _offset = _scroll mod _tile_w;

    for (var _tile_x = _arena_x1 - _offset; _tile_x < _arena_x2; _tile_x += _tile_w) {
        var _draw_x1 = max(_tile_x, _arena_x1);
        var _draw_x2 = min(_tile_x + _tile_w, _arena_x2);
        var _draw_w = _draw_x2 - _draw_x1;

        if (_draw_w <= 0) continue;

        var _src_x = (_draw_x1 - _tile_x) / _scale_x;
        var _src_w = _draw_w / _scale_x;

        draw_sprite_part_ext(
            _arena_sprite,
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

draw_set_alpha(1);
