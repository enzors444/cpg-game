if (operacao == "REROLL") {
    rerrolar_mao();
    exit;
}

if (operacao == "=") {
    var _qtd_cartas = array_length(global.cartas_selecionadas);
    var _qtd_ops    = array_length(global.ops_selecionadas);

    if (_qtd_cartas < 2 || _qtd_ops < 1 || _qtd_ops != _qtd_cartas - 1) exit;

    var _enemy = instance_find(obj_enemy, 0);
    if (_enemy == noone) exit;

    var _resultado = calcular_resultado(global.cartas_selecionadas, global.ops_selecionadas);
    var _acertou_exato = (_resultado == global.enemy_life);
    var _dano = max(0, _resultado);
    global.enemy_life = max(0, global.enemy_life - _dano);

    if (global.enemy_life <= 0) {
        if (_acertou_exato) {
            global.bonus_tentativas_proxima += 1;
        }

        recomprar_cartas();
        proximo_inimigo();
    } else {
        global.tentativas--;
        if (global.tentativas <= 0) {
            game_over();
        } else {
            recomprar_cartas();
        }
    }

    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];

    with (obj_carta) {
        if (!carta_selecao) {
            selecionada = false;
            image_blend = c_white;
        }
    }

    with (obj_btn_operacao) {
        selecionada = false;
        image_blend = c_white;
    }
} else {
    if (!selecionada && array_length(global.ops_selecionadas) < 4) {
        selecionada = true;
        array_push(global.ops_selecionadas, operacao);
        image_blend = c_yellow;
    } else if (selecionada) {
        selecionada = false;
        var _idx = array_get_index(global.ops_selecionadas, operacao);
        if (_idx != -1) array_delete(global.ops_selecionadas, _idx, 1);
        image_blend = c_white;
    }
}
