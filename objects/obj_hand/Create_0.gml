// inicia a mão com 5 cartas aleatórias
mao = [];
for (var i = 0; i < 5; i++) {
    array_push(mao, irandom(9)); // número de 0 a 9
}

// cria as instâncias das cartas na tela
atualizar_mao();

function atualizar_mao() {
    // destroi cartas antigas
	var _gap   = 120;
	var _start = room_width/2 - (_gap * 2);
	

	for (var i = 0; i < array_length(mao); i++) {
	    var _c         = instance_create_layer(_start + i * _gap, 100, "Instances", obj_carta);
	    _c.numero      = mao[i];
	    _c.image_index = mao[i];
	}
}