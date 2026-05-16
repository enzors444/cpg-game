// inicia a mão com 5 cartas aleatórias
mao = [];
for (var i = 0; i < 5; i++) {
    array_push(mao, irandom(9)); // número de 0 a 9
}

// cria as instâncias das cartas na tela
atualizar_mao();

function atualizar_mao() {
    // destroi cartas antigas
    with (obj_carta) { instance_destroy(); }
    
    var _gap   = 100;
    var _start = room_width/2 - (_gap * 2);
    
    for (var i = 0; i < array_length(mao); i++) {
        var _inst         = instance_create_layer(_start + i * _gap, room_height - 80, "Instances", obj_carta);
        _inst.numero      = mao[i];
        _inst.image_index = mao[i];
    }
}