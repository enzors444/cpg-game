function atualizar_mao() {
    with (obj_carta) {
        if (!carta_selecao) instance_destroy();
    }

    var _gap   = 60;
    var _start = room_width / 2 - (_gap * (array_length(mao) - 1)) / 2;

    for (var i = 0; i < array_length(mao); i++) {
        var _c           = instance_create_layer(_start + i * _gap, 250, "Instances", obj_carta);
        _c.numero        = mao[i];
        _c.indice_mao    = i;
        _c.carta_selecao = false;
        _c.image_index   = mao[i];
    }
}

function contar_cartas_iguais(_numero, _indice_ignorado) {
    var _qtd = 0;

    for (var i = 0; i < array_length(mao); i++) {
        if (i != _indice_ignorado && mao[i] == _numero) {
            _qtd++;
        }
    }

    return _qtd;
}

function pode_receber_carta(_numero, _indice_ignorado) {
    return contar_cartas_iguais(_numero, _indice_ignorado) < 2;
}

function comprar_carta_valida(_indice_ignorado) {
    var _opcoes = [];

    for (var _numero = 0; _numero <= 9; _numero++) {
        if (pode_receber_carta(_numero, _indice_ignorado)) {
            array_push(_opcoes, _numero);
        }
    }

    return _opcoes[irandom(array_length(_opcoes) - 1)];
}

function substituir_carta(_numero) {
    var _idx = 0;
    if (array_length(global.indices_cartas_selecionadas) > 0) {
        _idx = global.indices_cartas_selecionadas[0];
    }

    if (!pode_receber_carta(_numero, _idx)) {
        _numero = comprar_carta_valida(_idx);
    }

    mao[_idx] = _numero;
    atualizar_mao();
}

// Inicia a mao com 5 cartas aleatorias.
mao = [];
for (var i = 0; i < 5; i++) {
    array_push(mao, comprar_carta_valida(-1));
}

atualizar_mao();
