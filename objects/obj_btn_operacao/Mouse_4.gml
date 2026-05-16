if (operacao == "=") {
    if (array_length(global.cartas_selecionadas) < 2 
    ||  array_length(global.ops_selecionadas)    < 1) exit;
    
    var _resultado = calcular_resultado(global.cartas_selecionadas, global.ops_selecionadas);
    
    if (_resultado > obj_enemy.vida) {
        obj_enemy.vida = 0;
    } else {
        global.tentativas--;
        if (global.tentativas <= 0) {
            game_over();
        } else {
            recomprar_cartas();
        }
    }
    
    global.cartas_selecionadas = [];
    global.ops_selecionadas    = [];
    with (obj_card)         { selecionada = false; image_blend = c_white; }
    with (obj_btn_operacao) { selecionada = false; image_blend = c_white; }

} else {
    if (!selecionada && array_length(global.ops_selecionadas) < 3) {
        selecionada = true;
        array_push(global.ops_selecionadas, operacao);
        image_blend = c_yellow;
    } else if (selecionada) {
        selecionada = false;
        var _idx = array_get_index(global.ops_selecionadas, operacao);
        array_delete(global.ops_selecionadas, _idx, 1);
        image_blend = c_white;
    }
}