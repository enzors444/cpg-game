function inicializar_roguelike() {
    if (!variable_global_exists("bonus_cargas_reroll_mao")) global.bonus_cargas_reroll_mao = 0;
    if (!variable_global_exists("bonus_precisao")) global.bonus_precisao = 0;
    if (!variable_global_exists("usos_numero_grudado_por_rodada")) global.usos_numero_grudado_por_rodada = 0;
    if (!variable_global_exists("usos_numero_grudado_rodada")) global.usos_numero_grudado_rodada = 0;
    if (!variable_global_exists("usos_coringa_numerico_por_rodada")) global.usos_coringa_numerico_por_rodada = 0;
    if (!variable_global_exists("usos_coringa_numerico_rodada")) global.usos_coringa_numerico_rodada = 0;
    if (!variable_global_exists("repeticoes_operacao_por_rodada")) global.repeticoes_operacao_por_rodada = 0;
    if (!variable_global_exists("repeticoes_operacao_rodada")) global.repeticoes_operacao_rodada = 0;
    if (!variable_global_exists("sem_volta_ativo")) global.sem_volta_ativo = false;
    if (!variable_global_exists("quadrado_desbloqueado")) global.quadrado_desbloqueado = false;
    if (!variable_global_exists("coringa_escolhendo_valor")) global.coringa_escolhendo_valor = false;
    if (!variable_global_exists("recompensa_roguelike_aberta")) global.recompensa_roguelike_aberta = false;
    if (!variable_global_exists("roguelike_opcoes")) global.roguelike_opcoes = [];
    if (!variable_global_exists("cartas_roguelike_escolhidas")) global.cartas_roguelike_escolhidas = [];
    if (!variable_global_exists("tem_sala_pendente_apos_recompensa")) global.tem_sala_pendente_apos_recompensa = false;
    if (!variable_global_exists("sala_pendente_apos_recompensa")) global.sala_pendente_apos_recompensa = noone;
}

function resetar_roguelike() {
    global.bonus_cargas_reroll_mao = 0;
    global.bonus_precisao = 0;
    global.usos_numero_grudado_por_rodada = 0;
    global.usos_numero_grudado_rodada = 0;
    global.usos_coringa_numerico_por_rodada = 0;
    global.usos_coringa_numerico_rodada = 0;
    global.repeticoes_operacao_por_rodada = 0;
    global.repeticoes_operacao_rodada = 0;
    global.sem_volta_ativo = false;
    global.quadrado_desbloqueado = false;
    global.coringa_escolhendo_valor = false;
    global.recompensa_roguelike_aberta = false;
    global.roguelike_opcoes = [];
    global.cartas_roguelike_escolhidas = [];
    global.tem_sala_pendente_apos_recompensa = false;
    global.sala_pendente_apos_recompensa = noone;
}

function cargas_reroll_maximas() {
    inicializar_roguelike();
    return 2 + global.bonus_cargas_reroll_mao;
}

function resetar_roguelike_por_rodada() {
    inicializar_roguelike();
    global.usos_numero_grudado_rodada = 0;
    global.usos_coringa_numerico_rodada = 0;
    global.repeticoes_operacao_rodada = 0;
}

function pode_usar_coringa_numerico() {
    inicializar_roguelike();
    return global.usos_coringa_numerico_rodada < global.usos_coringa_numerico_por_rodada;
}

function pode_repetir_operacao_rodada() {
    inicializar_roguelike();
    return global.repeticoes_operacao_rodada < global.repeticoes_operacao_por_rodada;
}

function tem_bonus_sem_volta() {
    inicializar_roguelike();
    return global.sem_volta_ativo;
}

function bonus_sem_volta_valor(_dano_base) {
    if (!tem_bonus_sem_volta() || _dano_base <= 0) return 0;
    return floor(_dano_base * 0.5);
}

function bonus_sem_volta_preview() {
    if (!tem_bonus_sem_volta() || !expressao_valida()) return 0;

    var _resultado = max(0, calcular_resultado_expressao());
    return bonus_sem_volta_valor(_resultado);
}

function adicionar_reroll_acerto_exato() {
    inicializar_roguelike();

    if (!variable_global_exists("cargas_reroll_mao")) global.cargas_reroll_mao = cargas_reroll_maximas();
    if (!variable_global_exists("fase_reroll_mao")) global.fase_reroll_mao = global.fase;

    if (global.fase_reroll_mao != global.fase) {
        global.fase_reroll_mao = global.fase;
        global.cargas_reroll_mao = cargas_reroll_maximas();
    }

    global.cargas_reroll_mao += 1;
}

function limpar_bonus_temporarios_fase() {
    inicializar_roguelike();
}

function frame_carta_roguelike(_id) {
    switch (_id) {
        case "exponencial": return 0;
        case "numero_grudado": return 1;
        case "precisao": return 2;
        case "mao_nova": return 3;
        case "coringa_numerico": return 4;
        case "sem_volta": return 5;
        case "eco_operacao": return 6;
    }

    return 0;
}

function carta_roguelike(_id) {
    switch (_id) {
        case "mao_nova":
            return {
                id: _id,
                nome: "Mao Nova",
                descricao: "+1 reroll por fase."
            };

        case "precisao":
            return {
                id: _id,
                nome: "Precisao",
                descricao: "Acerto exato: +1 tentativa."
            };

        case "numero_grudado":
            return {
                id: _id,
                nome: "Numero Grudado",
                descricao: "Junte 2 cartas em 1 numero."
            };

        case "coringa_numerico":
            return {
                id: _id,
                nome: "Coringa Numerico",
                descricao: "Shift + clique: escolha 0-9."
            };

        case "eco_operacao":
            return {
                id: _id,
                nome: "Eco Operacao",
                descricao: "Repita uma operacao."
            };

        case "sem_volta":
            return {
                id: _id,
                nome: "Sem Volta",
                descricao: "Trava cartas. +50% dano."
            };

        case "exponencial":
            return {
                id: _id,
                nome: "Exponencial",
                descricao: "Uso unico: ^2 em um numero."
            };
    }

    return {
        id: _id,
        nome: "Carta",
        descricao: ""
    };
}

function sortear_opcoes_roguelike(_qtd) {
    inicializar_roguelike();

    var _base = ["mao_nova", "precisao", "numero_grudado", "coringa_numerico", "eco_operacao", "sem_volta", "exponencial"];
    var _pool = [];

    for (var i = 0; i < array_length(_base); i++) {
        if (array_get_index(global.cartas_roguelike_escolhidas, _base[i]) == -1) {
            array_push(_pool, _base[i]);
        }
    }

    if (array_length(_pool) <= 0) {
        _pool = _base;
    }

    var _opcoes = [];

    repeat (min(_qtd, array_length(_pool))) {
        var _idx = irandom(array_length(_pool) - 1);
        array_push(_opcoes, _pool[_idx]);
        array_delete(_pool, _idx, 1);
    }

    return _opcoes;
}

function abrir_recompensa_roguelike() {
    inicializar_roguelike();

    if (instance_exists(obj_recompensa_roguelike)) {
        return;
    }

    limpar_expressao();
    global.roguelike_opcoes = sortear_opcoes_roguelike(3);
    global.recompensa_roguelike_aberta = true;
    global.jogo_pausado = true;

    tocar_sfx_unico("roguelike", roguelike, 0.9);

    instance_create_depth(0, 0, -100000, obj_recompensa_roguelike);
}

function aplicar_carta_roguelike(_id) {
    inicializar_roguelike();
    array_push(global.cartas_roguelike_escolhidas, _id);

    switch (_id) {
        case "mao_nova":
            global.bonus_cargas_reroll_mao += 1;
            global.cargas_reroll_mao += 1;
            break;

        case "precisao":
            global.bonus_precisao += 1;
            break;

        case "numero_grudado":
            global.usos_numero_grudado_por_rodada = max(1, global.usos_numero_grudado_por_rodada);
            break;

        case "coringa_numerico":
            global.usos_coringa_numerico_por_rodada = max(1, global.usos_coringa_numerico_por_rodada);
            break;

        case "eco_operacao":
            global.repeticoes_operacao_por_rodada += 1;
            break;

        case "sem_volta":
            global.sem_volta_ativo = true;
            break;

        case "exponencial":
            global.quadrado_desbloqueado = true;
            break;
    }
}

function consumir_exponencial_se_usado() {
    inicializar_roguelike();

    if (indice_quadrado_expressao() == -1) return false;

    var _idx = array_get_index(global.cartas_roguelike_escolhidas, "exponencial");
    if (_idx == -1) {
        global.quadrado_desbloqueado = false;
        return false;
    }

    array_delete(global.cartas_roguelike_escolhidas, _idx, 1);
    global.quadrado_desbloqueado = array_get_index(global.cartas_roguelike_escolhidas, "exponencial") != -1;
    return true;
}

function fechar_recompensa_roguelike() {
    inicializar_roguelike();
    global.recompensa_roguelike_aberta = false;
    global.jogo_pausado = false;

    var _ir_para_sala_pendente = global.tem_sala_pendente_apos_recompensa;
    var _sala_pendente = global.sala_pendente_apos_recompensa;
    var _continuar_caminhada = variable_global_exists("caminhada_continuar_apos_recompensa")
        && global.caminhada_continuar_apos_recompensa;

    global.tem_sala_pendente_apos_recompensa = false;
    global.sala_pendente_apos_recompensa = noone;
    global.caminhada_continuar_apos_recompensa = false;

    with (obj_recompensa_roguelike) {
        instance_destroy();
    }

    if (_ir_para_sala_pendente && _sala_pendente != noone) {
        iniciar_transicao_fase(fase_da_sala(_sala_pendente), _sala_pendente);
    } else if (_continuar_caminhada) {
        global.progresso_visual_inicio = global.progresso_visual;
        global.progresso_visual_alvo = global.inimigo_atual_fase;
        iniciar_caminhada_arena(false, true);
    }
}
