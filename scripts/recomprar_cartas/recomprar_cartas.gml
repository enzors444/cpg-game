function recomprar_cartas() {
    // repõe só as cartas que foram usadas
    for (var i = 0; i < array_length(global.cartas_selecionadas); i++) {
        var _idx = global.cartas_selecionadas[i]; // índice na mão
        obj_hand.mao[_idx] = irandom(9);
    }
    global.cartas_selecionadas = [];
    global.ops_selecionadas    = [];
    obj_hand.atualizar_mao();
}