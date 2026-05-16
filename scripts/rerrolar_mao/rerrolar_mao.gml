function rerrolar_mao() {
    inicializar_roguelike();

    if (!variable_global_exists("cargas_reroll_mao")) global.cargas_reroll_mao = cargas_reroll_maximas();
    if (!variable_global_exists("fase_reroll_mao")) global.fase_reroll_mao = global.fase;

    if (global.fase_reroll_mao != global.fase) {
        global.fase_reroll_mao = global.fase;
        global.cargas_reroll_mao = cargas_reroll_maximas();
    }

    if (global.jogo_pausado || global.cargas_reroll_mao <= 0) {
        return false;
    }

    var _hand = instance_find(obj_hand, 0);
    if (_hand == noone) {
        return false;
    }

    for (var i = 0; i < array_length(_hand.mao); i++) {
        _hand.mao[i] = _hand.comprar_carta_valida(i);
    }

    global.cargas_reroll_mao--;
    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];

    with (obj_btn_operacao) {
        selecionada = false;
        image_blend = c_white;
    }

    _hand.atualizar_mao();

    return true;
}
