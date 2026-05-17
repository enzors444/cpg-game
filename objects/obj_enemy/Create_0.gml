sprites_enemy = [
    spr_enemy_0,
	spr_enemy_1,
	spr_enemy_2,
	spr_enemy_3,
	spr_enemy_4,
	spr_enemy_5,
	spr_enemy_6,
	spr_enemy_7,
	spr_enemy_8,
	spr_enemy_9
];

sprites_enemy_aparecendo = [
    spr_enemy_0_aparecendo,
    spr_enemy_1_aparecendo,
    spr_enemy_2_aparecendo,
    spr_enemy_3_aparecendo,
    spr_enemy_4_aparecendo,
    spr_enemy_5_aparecendo,
    spr_enemy_6_aparecendo,
    spr_enemy_7_aparecendo,
    spr_enemy_8_aparecendo,
    spr_enemy_9_aparecendo
];

sprites_enemy_morrendo = [
    spr_enemy_0_morrendo,
    spr_enemy_1_morrendo,
    spr_enemy_2_morrendo,
    spr_enemy_3_morrendo,
    spr_enemy_4_morrendo,
    spr_enemy_5_morrendo,
    spr_enemy_6_morrendo,
    spr_enemy_7_morrendo,
    spr_enemy_8_morrendo,
    spr_enemy_9_morrendo
];

boss_visual = false;
boss_fase = 0;
boss_estagio_visual = 0;
digito_posicao = 0;
numero_enemy = 0;
enemy_estado = "parado";
enemy_anim_timer = 0;
enemy_anim_duration = 0;
enemy_idle_speed = image_speed;
enemy_morte_proximo = false;
enemy_morte_concluida = false;

enemy_animar_sprite = function(_sprite, _estado, _duracao) {
    enemy_estado = _estado;
    enemy_anim_timer = 0;
    enemy_anim_duration = max(1, _duracao);
    sprite_index = _sprite;
    image_index = 0;
    image_speed = max(0.01, (sprite_get_number(_sprite) - 0.01) / enemy_anim_duration);
};

enemy_ir_para_parado = function() {
    enemy_estado = "parado";
    sprite_index = sprites_enemy[numero_enemy];
    image_index = 0;
    image_speed = enemy_idle_speed;
};

iniciar_aparecendo_enemy = function(_numero) {
    numero_enemy = clamp(floor(_numero), 0, 9);
    enemy_morte_proximo = false;
    enemy_morte_concluida = false;
    visible = true;

    enemy_animar_sprite(sprites_enemy_aparecendo[numero_enemy], "aparecendo", 24);
};

iniciar_morte_enemy = function(_proximo) {
    if (boss_visual) return;

    if (enemy_estado == "morrendo") {
        if (_proximo) {
            enemy_morte_proximo = true;
            enemy_morte_concluida = false;
        }

        return;
    }

    enemy_morte_proximo = _proximo;
    enemy_morte_concluida = false;
    visible = true;

    enemy_animar_sprite(sprites_enemy_morrendo[numero_enemy], "morrendo", 22);
};

ocultar_numero_enemy = function() {
    visible = false;
    enemy_estado = "oculto";
    enemy_morte_proximo = false;
    enemy_morte_concluida = false;
    image_index = 0;
    image_speed = 0;
};

definir_numero_enemy = function(_numero, _posicao) {
    boss_visual = false;
    digito_posicao = _posicao;
    iniciar_aparecendo_enemy(_numero);
};

atualizar_numero_enemy = function(_numero, _visivel) {
    if (boss_visual) return;

    var _numero_atualizado = clamp(floor(_numero), 0, 9);

    if (!_visivel) {
        if (visible && enemy_estado != "morrendo") {
            iniciar_morte_enemy(false);
        }

        return;
    }

    if (!visible) {
        iniciar_aparecendo_enemy(_numero_atualizado);
        return;
    }

    if (enemy_estado == "morrendo") return;

    if (_numero_atualizado != numero_enemy) {
        iniciar_aparecendo_enemy(_numero_atualizado);
        return;
    }

    if (enemy_estado == "parado" && sprite_index != sprites_enemy[numero_enemy]) {
        enemy_ir_para_parado();
    }
};

definir_boss_enemy = function(_fase, _estagio) {
    boss_visual = true;
    boss_fase = _fase;
    boss_estagio_visual = _estagio;
    digito_posicao = 0;
    numero_enemy = 0;
    sprite_index = sprite_boss_da_fase(boss_fase, boss_estagio_visual);
    image_index = 0;
    image_speed = 0.12;
};

definir_numero_enemy(irandom(9), 0);
