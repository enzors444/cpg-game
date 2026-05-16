function inicializar_roguelike() {
    if (!variable_global_exists("bonus_cargas_reroll_mao")) global.bonus_cargas_reroll_mao = 0;
    if (!variable_global_exists("bonus_precisao")) global.bonus_precisao = 0;
    if (!variable_global_exists("bonus_cartas_seguidas_temporario")) global.bonus_cartas_seguidas_temporario = 0;
    if (!variable_global_exists("fase_bonus_numero_grudado")) global.fase_bonus_numero_grudado = -1;
    if (!variable_global_exists("usos_coringa_numerico_por_rodada")) global.usos_coringa_numerico_por_rodada = 0;
    if (!variable_global_exists("usos_coringa_numerico_rodada")) global.usos_coringa_numerico_rodada = 0;
    if (!variable_global_exists("coringa_escolhendo_valor")) global.coringa_escolhendo_valor = false;
    if (!variable_global_exists("recompensa_roguelike_aberta")) global.recompensa_roguelike_aberta = false;
    if (!variable_global_exists("roguelike_opcoes")) global.roguelike_opcoes = [];
    if (!variable_global_exists("cartas_roguelike_escolhidas")) global.cartas_roguelike_escolhidas = [];
}

function resetar_roguelike() {
    global.bonus_cargas_reroll_mao = 0;
    global.bonus_precisao = 0;
    global.bonus_cartas_seguidas_temporario = 0;
    global.fase_bonus_numero_grudado = -1;
    global.usos_coringa_numerico_por_rodada = 0;
    global.usos_coringa_numerico_rodada = 0;
    global.coringa_escolhendo_valor = false;
    global.recompensa_roguelike_aberta = false;
    global.roguelike_opcoes = [];
    global.cartas_roguelike_escolhidas = [];
}

function cargas_reroll_maximas() {
    inicializar_roguelike();
    return 2 + global.bonus_cargas_reroll_mao;
}

function resetar_roguelike_por_rodada() {
    inicializar_roguelike();
    global.usos_coringa_numerico_rodada = 0;
}

function pode_usar_coringa_numerico() {
    inicializar_roguelike();
    return global.usos_coringa_numerico_rodada < global.usos_coringa_numerico_por_rodada;
}

function limpar_bonus_temporarios_fase() {
    inicializar_roguelike();
    global.bonus_cartas_seguidas_temporario = 0;
    global.fase_bonus_numero_grudado = -1;
}

function carta_roguelike(_id) {
    switch (_id) {
        case "mao_nova":
            return {
                id: _id,
                nome: "Mao Nova",
                descricao: "+1 carga de reroll por fase."
            };

        case "precisao":
            return {
                id: _id,
                nome: "Precisao",
                descricao: "Acerto exato da +1 tentativa extra."
            };

        case "numero_grudado":
            return {
                id: _id,
                nome: "Numero Grudado",
                descricao: "Nesta fase, numeros podem ter +1 carta."
            };

        case "coringa_numerico":
            return {
                id: _id,
                nome: "Coringa Numerico",
                descricao: "Shift + clique em 1 carta por rodada para escolher 0-9."
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

    var _base = ["mao_nova", "precisao", "numero_grudado", "coringa_numerico"];
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
            global.bonus_cartas_seguidas_temporario += 1;
            global.fase_bonus_numero_grudado = global.fase;
            break;

        case "coringa_numerico":
            global.usos_coringa_numerico_por_rodada = max(1, global.usos_coringa_numerico_por_rodada);
            break;
    }
}

function fechar_recompensa_roguelike() {
    inicializar_roguelike();
    global.recompensa_roguelike_aberta = false;
    global.jogo_pausado = false;

    with (obj_recompensa_roguelike) {
        instance_destroy();
    }
}
