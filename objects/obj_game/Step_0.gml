if (variable_global_exists("em_caminhada_arena") && global.em_caminhada_arena) {
    global.caminhada_arena_timer += 1;

    var _t = min(1, global.caminhada_arena_timer / max(1, global.caminhada_arena_duracao));
    var _suave = _t * _t * (3 - 2 * _t);

    global.arena_scroll = lerp(
        global.caminhada_arena_scroll_inicio,
        global.caminhada_arena_scroll_alvo,
        _suave
    );

    with (obj_player) {
        sprite_index = spr_player_walking;
        x = room_width / 3 + sin(global.caminhada_arena_timer * 0.25) * 2;
        y = 110 + global.ui_top_space;
    }

    if (_t >= 1) {
        finalizar_caminhada_arena();
    }

    exit;
}

if (global.precisa_atualizar_botoes) {
    global.precisa_atualizar_botoes = false;
    criar_botoes_operacao();
}

