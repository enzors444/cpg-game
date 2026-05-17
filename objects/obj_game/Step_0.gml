if (!variable_global_exists("pause_ativo")) {
    global.pause_ativo = false;
}

if (!variable_global_exists("admin_menu_ativo")) {
    global.admin_menu_ativo = false;
}

var _combo_admin = keyboard_check(vk_control)
    && keyboard_check(vk_shift)
    && keyboard_check_pressed(ord("A"));

if (!global.pause_ativo
&& !global.admin_menu_ativo
&& !global.jogo_pausado
&& (!variable_global_exists("jogo_vencido") || !global.jogo_vencido)
&& _combo_admin) {
    global.admin_menu_ativo = true;
    instance_create_depth(0, 0, -100000, obj_admin_menu);
    exit;
}

if (global.admin_menu_ativo) {
    if (!instance_exists(obj_admin_menu)) {
        instance_create_depth(0, 0, -100000, obj_admin_menu);
    }

    exit;
}

if (global.pause_ativo) {
    if (!instance_exists(obj_pause_menu)) {
        instance_create_depth(0, 0, -100000, obj_pause_menu);
    }

    exit;
}

if (!variable_global_exists("boss_display_stream_texto")) {
    global.boss_display_stream_texto = "";
    global.boss_display_stream_pos = 0;
    global.boss_display_stream_vel = 0.22;
}

if (variable_global_exists("boss_ativo") && global.boss_ativo) {
    var _fala_boss = boss_fala_atual();

    if (global.boss_display_stream_texto != _fala_boss) {
        global.boss_display_stream_texto = _fala_boss;
        global.boss_display_stream_pos = 1;
    } else {
        global.boss_display_stream_pos = min(
            string_length(global.boss_display_stream_texto),
            global.boss_display_stream_pos + global.boss_display_stream_vel
        );
    }
} else {
    global.boss_display_stream_texto = "";
    global.boss_display_stream_pos = 0;
}

var _pode_pausar = !global.jogo_pausado
    && !global.jogo_vencido
    && (!variable_global_exists("game_over_ativo") || !global.game_over_ativo)
    && (!variable_global_exists("renzo_game_over_ativo") || !global.renzo_game_over_ativo)
    && (!variable_global_exists("recompensa_roguelike_aberta") || !global.recompensa_roguelike_aberta)
    && (!variable_global_exists("coringa_escolhendo_valor") || !global.coringa_escolhendo_valor)
    && (!variable_global_exists("transicao_fase_ativa") || !global.transicao_fase_ativa)
    && (!variable_global_exists("morte_numeros_ativa") || !global.morte_numeros_ativa);

if (_pode_pausar && keyboard_check_pressed(vk_escape)) {
    global.pause_ativo = true;
    global.jogo_pausado = true;
    instance_create_depth(0, 0, -100000, obj_pause_menu);
    exit;
}

if (variable_global_exists("em_caminhada_arena") && global.em_caminhada_arena) {
    global.caminhada_arena_timer += 1;

    var _t = min(1, global.caminhada_arena_timer / max(1, global.caminhada_arena_duracao));
    var _suave = _t * _t * (3 - 2 * _t);

    global.arena_scroll = lerp(
        global.caminhada_arena_scroll_inicio,
        global.caminhada_arena_scroll_alvo,
        _suave
    );
    global.progresso_visual = lerp(
        global.progresso_visual_inicio,
        global.progresso_visual_alvo,
        _suave
    );

    with (obj_player) {
        sprite_index = spr_player_walking;
        x = player_x_da_fase(global.fase) + sin(global.caminhada_arena_timer * 0.25) * 2;
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
