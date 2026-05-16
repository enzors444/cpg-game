if (carta_selecao) {
    global.carta_escolhida = numero;
    with (obj_card_selection) { confirmar(); }
    exit;
}

if (global.jogo_pausado || indice_mao == -1) exit;

// Seleciona/deseleciona uma carta da mao.
if (!selecionada) {
    if (!pode_adicionar_carta_expressao(numero, indice_mao)) exit;

    selecionada = true;
    array_push(global.cartas_selecionadas, numero);
    array_push(global.indices_cartas_selecionadas, indice_mao);
    array_push(global.expressao_partes, { tipo: "carta", valor: numero, indice: indice_mao });

    if (!expressao_respeita_limite_numeros(global.expressao_partes)) {
        remover_expressao_a_partir(array_length(global.expressao_partes) - 1);
        exit;
    }

    if (pode_usar_coringa_numerico() && keyboard_check(vk_shift)) {
        var _seletor_coringa = instance_create_depth(0, 0, -100000, obj_coringa_escolha);
        _seletor_coringa.indice_expressao = array_length(global.expressao_partes) - 1;
        _seletor_coringa.indice_mao = indice_mao;
        global.coringa_escolhendo_valor = true;
        global.jogo_pausado = true;
    }
} else {
    for (var i = 0; i < array_length(global.expressao_partes); i++) {
        var _parte = global.expressao_partes[i];
        if (_parte.tipo == "carta" && _parte.indice == indice_mao) {
            remover_expressao_a_partir(i);
            exit;
        }
    }

    selecionada = false;
    image_blend = c_white;
}
