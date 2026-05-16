var _pool = [0,1,2,3,4,5,6,7,8,9];
cartas = array_create(3);
randomise();

for (var i = 0; i < 3; i++) {
    var _idx = irandom(array_length(_pool) - 1);
    cartas[i] = _pool[_idx];
    array_delete(_pool, _idx, 1);
}

var _gap   = 90;
var _start = room_width / 2 - _gap;

for (var i = 0; i < 3; i++) {
    var _inst           = instance_create_layer(_start + i * _gap, room_height / 2 + global.ui_top_space / 2, "Instances", obj_carta);
    _inst.numero        = cartas[i];
    _inst.carta_selecao = true;
    _inst.image_index   = cartas[i];
}

function confirmar() {
    var _hand = instance_find(obj_hand, 0);
    if (_hand != noone && global.carta_escolhida != -1) {
        _hand.substituir_carta(global.carta_escolhida);
    }

    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];
    global.carta_escolhida = -1;

    with (obj_carta) {
        if (carta_selecao) instance_destroy();
    }

    with (obj_btn_operacao) {
        selecionada = false;
        image_blend = c_white;
    }

    instance_destroy();
    global.jogo_pausado = false;
}
