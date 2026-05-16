if (global.jogo_pausado) {
    exit;
}

if (operacao == "REROLL") {
    rerrolar_mao();
    exit;
}

if (operacao == "CLEAR") {
    limpar_expressao();
    exit;
}

if (operacao == "(" || operacao == ")") {
    if (!pode_adicionar_parentese_expressao(operacao)) exit;

    array_push(global.expressao_partes, { tipo: "paren", valor: operacao });
    exit;
}

if (operacao == "=") {
    if (!expressao_valida()) exit;

    var _enemy = instance_find(obj_enemy, 0);
    if (_enemy == noone) exit;

    var _resultado = calcular_resultado_expressao();
    var _acertou_exato = (_resultado == global.enemy_life);
    var _dano = max(0, _resultado);
    global.enemy_life = max(0, global.enemy_life - _dano);

    if (global.enemy_life <= 0) {
        if (_acertou_exato) {
            var _bonus_exato = 1;
            if (variable_global_exists("bonus_precisao")) {
                _bonus_exato += global.bonus_precisao;
            }

            global.bonus_tentativas_proxima += _bonus_exato;
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
    global.expressao_partes = [];

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
        if (!pode_adicionar_operacao_expressao()) exit;

        selecionada = true;
        array_push(global.ops_selecionadas, operacao);
        array_push(global.expressao_partes, { tipo: "op", valor: operacao });
        image_blend = c_yellow;
    } else if (selecionada) {
        for (var i = 0; i < array_length(global.expressao_partes); i++) {
            var _parte = global.expressao_partes[i];
            if (_parte.tipo == "op" && _parte.valor == operacao) {
                remover_expressao_a_partir(i);
                exit;
            }
        }

        selecionada = false;
        image_blend = c_white;
    }
}
