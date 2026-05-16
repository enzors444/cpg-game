function recomprar_cartas() {
    var _hand = instance_find(obj_hand, 0);

    if (_hand != noone) {
        // Repoe so as cartas que foram usadas.
        for (var i = 0; i < array_length(global.indices_cartas_selecionadas); i++) {
            var _idx = global.indices_cartas_selecionadas[i];
            _hand.mao[_idx] = _hand.comprar_carta_valida(_idx);

            if (variable_instance_exists(_hand, "mao_coringa")) {
                _hand.mao_coringa[_idx] = false;
            }
        }

        _hand.atualizar_mao();
    }

    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];
}
