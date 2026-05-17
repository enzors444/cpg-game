function game_over_copiar_array(_arr) {
    var _copia = [];

    for (var i = 0; i < array_length(_arr); i++) {
        array_push(_copia, _arr[i]);
    }

    return _copia;
}

function game_over_salvar_checkpoint_fase() {
    inicializar_roguelike();

    global.checkpoint_fase = global.fase;
    global.checkpoint_bonus_cargas_reroll_mao = global.bonus_cargas_reroll_mao;
    global.checkpoint_bonus_precisao = global.bonus_precisao;
    global.checkpoint_usos_numero_grudado_por_rodada = global.usos_numero_grudado_por_rodada;
    global.checkpoint_usos_coringa_numerico_por_rodada = global.usos_coringa_numerico_por_rodada;
    global.checkpoint_repeticoes_operacao_por_rodada = global.repeticoes_operacao_por_rodada;
    global.checkpoint_sem_volta_ativo = global.sem_volta_ativo;
    global.checkpoint_quadrado_desbloqueado = global.quadrado_desbloqueado;
    global.checkpoint_exponencial_usado_batalha = global.exponencial_usado_batalha;
    global.checkpoint_cartas_roguelike_escolhidas = game_over_copiar_array(global.cartas_roguelike_escolhidas);
}

function game_over_restaurar_checkpoint_fase() {
    if (!variable_global_exists("checkpoint_fase")) return;

    global.fase = global.checkpoint_fase;
    global.bonus_cargas_reroll_mao = global.checkpoint_bonus_cargas_reroll_mao;
    global.bonus_precisao = global.checkpoint_bonus_precisao;
    global.usos_numero_grudado_por_rodada = global.checkpoint_usos_numero_grudado_por_rodada;
    global.usos_numero_grudado_rodada = 0;
    global.usos_coringa_numerico_por_rodada = global.checkpoint_usos_coringa_numerico_por_rodada;
    global.usos_coringa_numerico_rodada = 0;
    global.repeticoes_operacao_por_rodada = global.checkpoint_repeticoes_operacao_por_rodada;
    global.repeticoes_operacao_rodada = 0;
    global.sem_volta_ativo = global.checkpoint_sem_volta_ativo;
    global.quadrado_desbloqueado = global.checkpoint_quadrado_desbloqueado;
    global.exponencial_usado_batalha = global.checkpoint_exponencial_usado_batalha;
    global.coringa_escolhendo_valor = false;
    global.recompensa_roguelike_aberta = false;
    global.roguelike_opcoes = [];
    global.cartas_roguelike_escolhidas = game_over_copiar_array(global.checkpoint_cartas_roguelike_escolhidas);
    global.tem_sala_pendente_apos_recompensa = false;
    global.sala_pendente_apos_recompensa = noone;
}

function game_over_filtrar_resposta(_texto) {
    var _limpo = "";

    for (var i = 1; i <= string_length(_texto); i++) {
        var _char = string_char_at(_texto, i);
        var _codigo = ord(_char);

        if (_codigo >= ord("0") && _codigo <= ord("9")) {
            _limpo += _char;
        }
    }

    return string_copy(_limpo, 1, 5);
}

function game_over_gerar_equacao(_nivel) {
    var _dificuldade = max(1, _nivel + global.fase);
    var _tipo = min(4, floor((_dificuldade - 1) / 2));
    var _x = irandom_range(3 + _dificuldade, 8 + _dificuldade * 2);
    var _a = 0;
    var _b = 0;
    var _resultado = 0;
    var _texto = "";

    switch (_tipo) {
        case 0:
            _a = irandom_range(3, 9 + _dificuldade);
            _resultado = _x + _a;
            _texto = "x + " + string(_a) + " = " + string(_resultado);
            break;

        case 1:
            _a = irandom_range(2, max(2, min(_x - 1, 8 + _dificuldade)));
            _resultado = _x - _a;
            _texto = "x - " + string(_a) + " = " + string(_resultado);
            break;

        case 2:
            _a = irandom_range(2, 4 + floor(_dificuldade / 3));
            _resultado = _a * _x;
            _texto = string(_a) + "x = " + string(_resultado);
            break;

        case 3:
            _a = irandom_range(2, 5 + floor(_dificuldade / 3));
            _b = irandom_range(2, 9 + _dificuldade);
            _resultado = _a * _x + _b;
            _texto = string(_a) + "x + " + string(_b) + " = " + string(_resultado);
            break;

        default:
            _a = irandom_range(3, 7 + floor(_dificuldade / 4));
            _b = irandom_range(2, min(_a * _x - 1, 12 + _dificuldade));
            _resultado = _a * _x - _b;
            _texto = string(_a) + "x - " + string(_b) + " = " + string(_resultado);
            break;
    }

    return {
        texto: _texto,
        resposta: _x
    };
}

function game_over_iniciar_desafio() {
    if (!variable_global_exists("game_over_nivel")) global.game_over_nivel = 0;

    global.renzo_game_over_ativo = false;
    global.game_over_nivel += 1;

    var _equacao = game_over_gerar_equacao(global.game_over_nivel);

    global.game_over_ativo = true;
    global.game_over_fase = global.fase;
    global.game_over_equacao = _equacao.texto;
    global.game_over_resposta = _equacao.resposta;
    global.game_over_timer_max = max(540, 1080 - min(420, global.game_over_nivel * 30));
    global.game_over_timer = global.game_over_timer_max;
    global.jogo_pausado = true;

    tocar_sfx_unico("gameover", gameover_sfx, 1);
    tocar_musica(gameover_music);

    if (!instance_exists(obj_game_over)) {
        instance_create_depth(0, 0, -100000, obj_game_over);
    }
}

function game_over_deve_cena_renzo() {
    return variable_global_exists("fase")
        && global.fase == 3
        && variable_global_exists("boss_ativo")
        && global.boss_ativo
        && variable_global_exists("boss_tipo")
        && global.boss_tipo == "desafio";
}

function game_over_iniciar_cena_renzo() {
    global.renzo_game_over_ativo = true;
    global.renzo_game_over_timer = 0;
    global.renzo_game_over_duracao = 112;
    global.renzo_game_over_disparo_inicio = 24;
    global.renzo_game_over_impacto = 82;
    global.renzo_game_over_hadouken_tocado = false;
    global.renzo_game_over_boss_x = room_width * 0.67;
    global.renzo_game_over_boss_y = 80 + global.ui_top_space;
    global.renzo_game_over_boss_scale = escala_boss_da_fase(3);
    global.renzo_game_over_player_x = room_width / 3;
    global.renzo_game_over_player_y = 110 + global.ui_top_space;
    global.game_over_ativo = false;
    global.jogo_pausado = true;

    for (var i = 0; i < instance_number(obj_enemy); i++) {
        var _enemy = instance_find(obj_enemy, i);

        if (variable_instance_exists(_enemy, "boss_visual")
        && _enemy.boss_visual
        && _enemy.boss_fase == 3) {
            var _renzo_scale = abs(_enemy.image_xscale);
            global.renzo_game_over_boss_x = (_enemy.image_xscale < 0)
                ? _enemy.x - sprite_get_width(_enemy.sprite_index) * _renzo_scale
                : _enemy.x;
            global.renzo_game_over_boss_y = _enemy.y;
            global.renzo_game_over_boss_scale = _renzo_scale;
            break;
        }
    }

    if (instance_exists(obj_player)) {
        var _player = instance_find(obj_player, 0);
        global.renzo_game_over_player_x = _player.x;
        global.renzo_game_over_player_y = _player.y;
    }

    if (!instance_exists(obj_game_over)) {
        instance_create_depth(0, 0, -100000, obj_game_over);
    }
}

function game_over_acertar() {
    global.game_over_ativo = false;
    global.renzo_game_over_ativo = false;
    global.jogo_pausado = false;
    global.tentativas = max(1, ceil(global.ui_tentativas * 0.5));
    tocar_musica_fase(global.fase, global.boss_ativo);
}

function game_over_falhar() {
    var _fase = global.game_over_fase;

    global.game_over_ativo = false;
    global.renzo_game_over_ativo = false;
    global.jogo_pausado = false;
    global.jogo_vencido = false;
    global.em_caminhada_arena = false;

    game_over_restaurar_checkpoint_fase();

    global.fase = _fase;
    global.inimigo_atual_fase = 0;
    global.inimigos_por_fase = encontros_combate_da_fase(global.fase);
    global.bonus_tentativas_proxima = 0;
    global.cargas_reroll_mao = cargas_reroll_maximas();
    global.fase_reroll_mao = global.fase;
    global.arena_scroll = 0;

    var _sala = sala_da_fase(global.fase);
    global.game_over_reiniciar_sala = _sala;
    room_goto(GameOver);
}

function game_over() {
    if (variable_global_exists("game_over_ativo") && global.game_over_ativo) return;
    if (variable_global_exists("renzo_game_over_ativo") && global.renzo_game_over_ativo) return;

    if (game_over_deve_cena_renzo()) {
        game_over_iniciar_cena_renzo();
    } else {
        game_over_iniciar_desafio();
    }
}
