function tentativas_base_fase() {
    if (global.fase <= 1) return 4;
    if (global.fase == 2) return 4;
    return 5;
}

function sala_da_fase(_fase) {
    switch (_fase) {
        case 1: return Room1;
        case 2: return Room2;
        case 3: return Room3;
    }

    return Room1;
}

function fase_da_sala(_sala) {
    switch (_sala) {
        case Room1: return 1;
        case Room2: return 2;
        case Room3: return 3;
    }

    return 1;
}

function fase_da_sala_atual() {
    return fase_da_sala(room);
}

function iniciar_transicao_fase(_fase_alvo, _sala_alvo) {
    var _subtitulo = "A proxima sala comeca agora.";

    switch (_fase_alvo) {
        case 2:
            _subtitulo = "A segunda sala comeca agora.";
            break;

        case 3:
            _subtitulo = "A terceira sala comeca agora.";
            break;
    }

    global.transicao_fase_ativa = true;
    global.transicao_fase_timer = 0;
    global.transicao_fase_duracao = 95;
    global.transicao_fase_sala = _sala_alvo;
    global.transicao_fase_titulo = "Fase " + string(_fase_alvo);
    global.transicao_fase_subtitulo = _subtitulo;
    global.jogo_pausado = true;
    global.em_caminhada_arena = false;

    if (!instance_exists(obj_transicao_fase)) {
        instance_create_depth(0, 0, -100000, obj_transicao_fase);
    }
}

function sprite_arena_da_fase(_fase) {
    var _nome_sprite = "spr_arena_room" + string(_fase);
    var _sprite = asset_get_index(_nome_sprite);

    if (_sprite != -1) {
        return _sprite;
    }

    return spr_background;
}

function encontros_combate_da_fase(_fase) {
    switch (_fase) {
        case 1: return 4;
        case 2: return 5;
        case 3: return 6;
    }

    return 4;
}

function indice_boss_da_fase(_fase) {
    return encontros_combate_da_fase(_fase) - 1;
}

function encontro_atual_e_boss() {
    if (!variable_global_exists("fase")) return false;
    if (!variable_global_exists("inimigo_atual_fase")) return false;

    return global.inimigo_atual_fase >= indice_boss_da_fase(global.fase);
}

function recompensa_apos_encontro(_fase, _indice_derrotado) {
    switch (_fase) {
        case 1: return _indice_derrotado == indice_boss_da_fase(_fase);
        case 2: return _indice_derrotado == 1 || _indice_derrotado == indice_boss_da_fase(_fase);
        case 3: return _indice_derrotado == 2;
    }

    return false;
}

function progresso_recompensa_apos_encontro(_fase, _indice_derrotado) {
    return _indice_derrotado + 0.5;
}

function sortear_vida_inimigo() {
    var _indice = 0;

    if (variable_global_exists("inimigo_atual_fase")) _indice = global.inimigo_atual_fase;

    var _boss = encontro_atual_e_boss();

    switch (global.fase) {
        case 1:
            if (_boss) return 30;
            if (_indice <= 0) return irandom_range(10, 18);
            return irandom_range(16, 28);

        case 2:
            if (_boss) return irandom_range(430, 650);
            return irandom_range(100 + _indice * 90, 180 + _indice * 100);

        case 3:
            if (_boss) return irandom_range(3600, 5200);
            return irandom_range(1000 + _indice * 650, 1600 + _indice * 750);
    }

    return irandom_range(10, 25);
}

function criar_inimigos() {
    global.enemy_life = sortear_vida_inimigo();
    configurar_boss_atual();
    tocar_musica_fase(global.fase, global.boss_ativo);

    var _qtd_inimigos = global.fase + 1;
    var _base_x = 2 * room_width / 3;
    var _base_y = 80 + global.ui_top_space;
    var _gap = 55;

    for (var i = 0; i < _qtd_inimigos; i++) {
        var _peso = power(10, i);
        var _numero = floor(global.enemy_life / _peso) mod 10;

        var _enemy = instance_create_layer(_base_x - i * _gap, _base_y , "Instances", obj_enemy);
        _enemy.definir_numero_enemy(_numero, i);
        _enemy.visible = (i == 0 || global.enemy_life >= _peso);
        _enemy.image_xscale = 1.5;
        _enemy.image_blend = c_white;
    }
}

function criar_criticos_numeros_visiveis() {
    if (instance_exists(obj_enemy)) {
        tocar_sfx(critico, 1);
    }

    with (obj_enemy) {
        if (visible) {
            var _escala_x = abs(image_xscale);
            var _escala_y = abs(image_yscale);
            var _enemy_w = sprite_get_width(sprite_index) * _escala_x;
            var _enemy_h = sprite_get_height(sprite_index) * _escala_y;
            var _critical_w = sprite_get_width(spr_critical) * _escala_x;
            var _critical_h = sprite_get_height(spr_critical) * _escala_y;
            var _critical_x = x + _enemy_w / 2 - _critical_w / 2;
            var _critical_y = y + _enemy_h / 2 - _critical_h / 2;
            var _critical = instance_create_layer(_critical_x, _critical_y, "Instances", obj_critical);

            _critical.image_xscale = _escala_x;
            _critical.image_yscale = _escala_y;
        }
    }
}

function iniciar_caminhada_arena(_abrir_recompensa, _criar_inimigo_no_fim) {
    if (!variable_global_exists("arena_scroll")) global.arena_scroll = 0;
    if (!variable_global_exists("caminhada_arena_duracao_base")) global.caminhada_arena_duracao_base = 90;
    if (!variable_global_exists("caminhada_arena_scroll_passo")) global.caminhada_arena_scroll_passo = 180;
    if (!variable_global_exists("progresso_visual_inicio")) global.progresso_visual_inicio = global.inimigo_atual_fase;
    if (!variable_global_exists("progresso_visual_alvo")) global.progresso_visual_alvo = global.inimigo_atual_fase;

    global.em_caminhada_arena = true;
    global.jogo_pausado = true;
    global.caminhada_arena_timer = 0;
    global.caminhada_arena_duracao = global.caminhada_arena_duracao_base;
    global.caminhada_arena_scroll_inicio = global.arena_scroll;
    global.caminhada_arena_scroll_alvo = global.arena_scroll + global.caminhada_arena_scroll_passo;
    global.caminhada_abrir_recompensa = _abrir_recompensa;
    global.caminhada_criar_inimigo_no_fim = _criar_inimigo_no_fim;
    global.progresso_visual = global.progresso_visual_inicio;

    with (obj_player) {
        x = room_width / 3;
        y = 110 + global.ui_top_space;
        sprite_index = spr_player_walking;
    }
}

function finalizar_caminhada_arena() {
    global.em_caminhada_arena = false;
    global.jogo_pausado = false;
    global.arena_scroll = global.caminhada_arena_scroll_alvo;
    global.progresso_visual = global.progresso_visual_alvo;

    with (obj_player) {
        x = room_width / 3;
        y = 110 + global.ui_top_space;
        sprite_index = spr_player_idle;
        image_index = 0;
    }

    if (global.caminhada_criar_inimigo_no_fim) {
        criar_inimigos();
    }

    if (global.caminhada_abrir_recompensa) {
        abrir_recompensa_roguelike();
    }

    global.caminhada_abrir_recompensa = false;
    global.caminhada_criar_inimigo_no_fim = true;
}

function proximo_inimigo() {
    with (obj_enemy) {
        instance_destroy();
    }

    boss_resetar_estado();
    inicializar_roguelike();

    if (!variable_global_exists("inimigos_por_fase")) global.inimigos_por_fase = encontros_combate_da_fase(global.fase);
    if (!variable_global_exists("inimigo_atual_fase")) global.inimigo_atual_fase = 0;
    if (!variable_global_exists("fase_maxima")) global.fase_maxima = 3;

    var _fase_derrotada = global.fase;
    var _indice_derrotado = global.inimigo_atual_fase;
    var _abrir_recompensa = recompensa_apos_encontro(_fase_derrotada, _indice_derrotado);

    global.inimigo_atual_fase++;

    if (global.inimigo_atual_fase >= encontros_combate_da_fase(global.fase)) {
        limpar_bonus_temporarios_fase();

        if (global.fase < global.fase_maxima) {
            var _proxima_fase = global.fase + 1;
            global.precisa_atualizar_botoes = true;

            global.cartas_selecionadas = [];
            global.indices_cartas_selecionadas = [];
            global.ops_selecionadas = [];
            global.expressao_partes = [];

            if (_abrir_recompensa) {
                global.tem_sala_pendente_apos_recompensa = true;
                global.sala_pendente_apos_recompensa = sala_da_fase(_proxima_fase);
                global.progresso_visual_inicio = _indice_derrotado;
                global.progresso_visual_alvo = progresso_recompensa_apos_encontro(_fase_derrotada, _indice_derrotado);
                global.caminhada_continuar_apos_recompensa = false;
                iniciar_caminhada_arena(true, false);
            } else {
                global.fase = _proxima_fase;
                global.inimigo_atual_fase = 0;
                global.inimigos_por_fase = encontros_combate_da_fase(global.fase);
                iniciar_transicao_fase(global.fase, sala_da_fase(global.fase));
            }

            exit;
        }

        global.inimigo_atual_fase = 0;
        global.jogo_vencido = true;
        global.jogo_pausado = true;
        exit;
    }

    global.inimigos_por_fase = encontros_combate_da_fase(global.fase);

    resetar_roguelike_por_rodada();

    global.tentativas = tentativas_base_fase() + global.bonus_tentativas_proxima;
    global.bonus_tentativas_proxima = 0;
    global.ui_tentativas = global.tentativas;
    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];
    global.progresso_visual_inicio = _indice_derrotado;
    global.progresso_visual_alvo = global.inimigo_atual_fase;
    global.caminhada_continuar_apos_recompensa = false;

    if (_abrir_recompensa) {
        global.progresso_visual_alvo = progresso_recompensa_apos_encontro(_fase_derrotada, _indice_derrotado);
        global.caminhada_continuar_apos_recompensa = true;
        iniciar_caminhada_arena(true, false);
    } else {
        iniciar_caminhada_arena(false, true);
    }
}
