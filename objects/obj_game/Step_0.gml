if (global.precisa_atualizar_botoes) {
    global.precisa_atualizar_botoes = false;
    criar_botoes_operacao();
}

// Exemplo: abre as cartas ao pressionar espaco.
/*
if (keyboard_check_pressed(vk_space) && !global.jogo_pausado) {
    global.jogo_pausado = true;
    global.carta_escolhida = -1;
    instance_create_layer(0, 0, "Instances", obj_card_selection);
}
*/
