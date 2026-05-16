if (carta_selecao) {
    global.carta_escolhida = numero;
    with (obj_card_selection) { confirmar(); }
    exit;
}

if (global.jogo_pausado || indice_mao == -1) exit;

// Seleciona/deseleciona uma carta da mao.
if (!selecionada) {
    selecionada = true;
    array_push(global.cartas_selecionadas, numero);
    array_push(global.indices_cartas_selecionadas, indice_mao);
    image_blend = c_yellow;
} else {
    selecionada = false;
    var _idx = array_get_index(global.indices_cartas_selecionadas, indice_mao);
    if (_idx != -1) {
        array_delete(global.cartas_selecionadas, _idx, 1);
        array_delete(global.indices_cartas_selecionadas, _idx, 1);
    }
    image_blend = c_white;
}
