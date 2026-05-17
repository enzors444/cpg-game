if (variable_global_exists("fase") && (global.fase == 2 || global.fase == 3)) {
    var _u_color = shader_get_uniform(shd_enemy_recolor, "u_color");
    var _u_threshold = shader_get_uniform(shd_enemy_recolor, "u_threshold");
    var _u_fill_all = shader_get_uniform(shd_enemy_recolor, "u_fill_all");
    var _borda = 2;
    var _cor_borda = [0.0, 0.07, 0.24];
    var _cor_base = [0.0, 0.38, 1.0];

    if (global.fase == 3) {
        _cor_borda = [0.0, 0.16, 0.05];
        _cor_base = [0.0, 0.76, 0.18];
    }

    shader_set(shd_enemy_recolor);
    shader_set_uniform_f(_u_threshold, 0.16);
    shader_set_uniform_f(_u_fill_all, 1.0);
    shader_set_uniform_f(_u_color, _cor_borda[0], _cor_borda[1], _cor_borda[2], 1.0);
    draw_sprite_ext(sprite_index, image_index, x - _borda, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
    draw_sprite_ext(sprite_index, image_index, x + _borda, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
    draw_sprite_ext(sprite_index, image_index, x, y - _borda, image_xscale, image_yscale, image_angle, c_white, image_alpha);
    draw_sprite_ext(sprite_index, image_index, x, y + _borda, image_xscale, image_yscale, image_angle, c_white, image_alpha);

    shader_set_uniform_f(_u_fill_all, 0.0);
    shader_set_uniform_f(_u_color, _cor_base[0], _cor_base[1], _cor_base[2], 1.0);
    draw_self();
    shader_reset();
} else {
    draw_self();
}
