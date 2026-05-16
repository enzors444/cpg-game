function criar_inimigos() {
    global.enemy_life = 0;

    var _qtd_inimigos = global.fase + 1;
    var _base_x = 2 * room_width / 3;
    var _gap = 40;

    for (var i = 0; i < _qtd_inimigos; i++) {
        var _numero = irandom(9);

        if (i == _qtd_inimigos - 1 && _numero == 0) {
            _numero = irandom_range(1, 9);
        }

        var _enemy = instance_create_layer(_base_x - i * _gap, 100, "Instances", obj_enemy);
        _enemy.definir_numero_enemy(_numero, i);

        global.enemy_life += _numero * power(10, i);
    }
}

function proximo_inimigo() {
    with (obj_enemy) {
        instance_destroy();
    }

    global.tentativas = 3 + global.bonus_tentativas_proxima;
    global.bonus_tentativas_proxima = 0;
	global.ui_tentativas = global.tentativas;
    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];

    criar_inimigos();
}
