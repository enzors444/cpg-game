if (variable_global_exists("renzo_game_over_ativo") && global.renzo_game_over_ativo) {
    var _timer = global.renzo_game_over_timer;
    var _boss_scale = global.renzo_game_over_boss_scale;
    var _boss_x = global.renzo_game_over_boss_x;
    var _boss_y = global.renzo_game_over_boss_y;
    var _player_x = global.renzo_game_over_player_x;
    var _player_y = global.renzo_game_over_player_y;
    var _disparo_inicio = global.renzo_game_over_disparo_inicio;
    var _impacto = global.renzo_game_over_impacto;
    var _boss_frame = floor(_timer / 6) mod sprite_get_number(spr_mega_renzo_attack);
    var _boss_w = sprite_get_width(spr_mega_renzo_attack) * _boss_scale;
    var _boss_draw_x = _boss_x + _boss_w;

    draw_set_alpha(0.32);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);

    draw_set_alpha(1);
    draw_sprite_ext(spr_mega_renzo_attack, _boss_frame, _boss_draw_x, _boss_y, -_boss_scale, _boss_scale, 0, c_white, 1);

    if (_timer >= _disparo_inicio) {
        var _t = clamp((_timer - _disparo_inicio) / max(1, _impacto - _disparo_inicio), 0, 1);
        _t = _t * _t * (3 - 2 * _t);

        var _start_x = _boss_x + 4 * _boss_scale;
        var _start_y = _boss_y + 24 * _boss_scale;
        var _end_x = _player_x + 18;
        var _end_y = _player_y + 34;
        var _proj_x = lerp(_start_x, _end_x, _t);
        var _proj_y = lerp(_start_y, _end_y, _t);
        var _proj_frame = floor(_timer / 4) mod sprite_get_number(spr_mega_renzo_projetil);
        var _proj_scale = 0.16 + 0.02 * sin(_timer * 0.45);
        var _proj_w = sprite_get_width(spr_mega_renzo_projetil) * _proj_scale;
        var _proj_h = sprite_get_height(spr_mega_renzo_projetil) * _proj_scale;

        for (var _i = 3; _i >= 1; _i--) {
            var _trail_t = max(0, _t - _i * 0.055);
            var _trail_scale = _proj_scale * (1 - _i * 0.14);
            var _trail_w = sprite_get_width(spr_mega_renzo_projetil) * _trail_scale;
            var _trail_h = sprite_get_height(spr_mega_renzo_projetil) * _trail_scale;
            var _trail_x = lerp(_start_x, _end_x, _trail_t);
            var _trail_y = lerp(_start_y, _end_y, _trail_t);

            draw_sprite_ext(
                spr_mega_renzo_projetil,
                _proj_frame,
                _trail_x - _trail_w / 2,
                _trail_y - _trail_h / 2,
                _trail_scale,
                _trail_scale,
                0,
                c_white,
                0.18
            );
        }

        draw_sprite_ext(
            spr_mega_renzo_projetil,
            _proj_frame,
            _proj_x - _proj_w / 2,
            _proj_y - _proj_h / 2,
            _proj_scale,
            _proj_scale,
            0,
            c_white,
            1
        );

        if (_timer < _impacto - 10) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(make_color_rgb(90, 220, 255));
            draw_text(_boss_x + _boss_w / 2, _boss_y - 14, "RADUKEN!");
        }
    }

    if (_timer >= _impacto) {
        var _flash = 1 - clamp((_timer - _impacto) / 18, 0, 1);

        draw_set_alpha(0.65 * _flash);
        draw_set_color(c_white);
        draw_rectangle(0, 0, room_width, room_height, false);

        draw_set_alpha(0.55 * _flash);
        draw_set_color(c_red);
        draw_rectangle(0, 0, room_width, room_height, false);
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

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
