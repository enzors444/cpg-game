depth = -100000;

global.admin_menu_ativo = true;
admin_jogo_pausado_antes = global.jogo_pausado;
global.jogo_pausado = true;

admin_hover = -1;
admin_feedback = "";
admin_feedback_timer = 0;
admin_botoes = [
    { texto: "FASE 1", acao: "fase1", coluna: 0, linha: 0 },
    { texto: "BOSS 1", acao: "boss1", coluna: 1, linha: 0 },
    { texto: "FASE 2", acao: "fase2", coluna: 0, linha: 1 },
    { texto: "BOSS 2", acao: "boss2", coluna: 1, linha: 1 },
    { texto: "FASE 3", acao: "fase3", coluna: 0, linha: 2 },
    { texto: "BOSS 3", acao: "boss3", coluna: 1, linha: 2 },
    { texto: "COMPRAR TODAS", acao: "comprar", coluna: 0, linha: 3 },
    { texto: "FECHAR", acao: "fechar", coluna: 0, linha: 4 }
];

admin_restaurar_animacoes = function() {
    with (obj_enemy) {
        if (variable_instance_exists(id, "admin_image_speed")) image_speed = admin_image_speed;
    }

    with (obj_player) {
        if (variable_instance_exists(id, "admin_image_speed")) image_speed = admin_image_speed;
    }

    with (obj_critical) {
        if (variable_instance_exists(id, "admin_image_speed")) image_speed = admin_image_speed;
    }
};

admin_fechar = function() {
    admin_restaurar_animacoes();
    global.admin_menu_ativo = false;
    global.jogo_pausado = admin_jogo_pausado_antes;
    instance_destroy();
};

admin_comprar_todas = function() {
    inicializar_roguelike();

    var _habilidades = [
        "mao_nova",
        "precisao",
        "numero_grudado",
        "coringa_numerico",
        "eco_operacao",
        "sem_volta",
        "exponencial"
    ];

    for (var i = 0; i < array_length(_habilidades); i++) {
        var _id = _habilidades[i];

        if (array_get_index(global.cartas_roguelike_escolhidas, _id) == -1) {
            aplicar_carta_roguelike(_id);
        }
    }

    global.usos_numero_grudado_por_rodada = max(1, global.usos_numero_grudado_por_rodada);
    global.usos_coringa_numerico_por_rodada = max(1, global.usos_coringa_numerico_por_rodada);
    global.repeticoes_operacao_por_rodada = max(1, global.repeticoes_operacao_por_rodada);
    global.sem_volta_ativo = true;
    global.quadrado_desbloqueado = true;
    global.exponencial_usado_batalha = false;
    global.cargas_reroll_mao = cargas_reroll_maximas();
    global.fase_reroll_mao = global.fase;
    game_over_salvar_checkpoint_fase();

    admin_feedback = "Habilidades compradas";
    admin_feedback_timer = 90;
};

admin_ir_para = function(_fase, _boss) {
    _fase = clamp(_fase, 1, 3);

    admin_restaurar_animacoes();
    global.admin_menu_ativo = false;
    global.jogo_pausado = false;
    global.pause_ativo = false;
    global.admin_teleporte_ativo = true;
    global.admin_teleporte_fase = _fase;
    global.admin_teleporte_boss = _boss;

    with (obj_pause_menu) {
        instance_destroy();
    }

    var _sala = sala_da_fase(_fase);

    if (room == _sala) {
        room_restart();
    } else {
        room_goto(_sala);
    }

    instance_destroy();
};

with (obj_enemy) {
    admin_image_speed = image_speed;
    image_speed = 0;
}

with (obj_player) {
    admin_image_speed = image_speed;
    image_speed = 0;
}

with (obj_critical) {
    admin_image_speed = image_speed;
    image_speed = 0;
}
