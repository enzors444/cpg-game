if (!variable_global_exists("transicao_fase_ativa") || !global.transicao_fase_ativa) {
    instance_destroy();
    exit;
}

global.transicao_fase_timer += 1;

if (global.transicao_fase_timer >= global.transicao_fase_duracao) {
    var _sala_alvo = global.transicao_fase_sala;

    global.transicao_fase_ativa = false;
    global.jogo_pausado = false;

    room_goto(_sala_alvo);
}
