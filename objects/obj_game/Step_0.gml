// exemplo: abre as cartas ao pressionar espaço (troque pelo seu gatilho)
if (keyboard_check_pressed(vk_space) && !global.jogo_pausado) {
    global.jogo_pausado   = true;
    global.carta_escolhida = -1;
    instance_create_layer(0, 0, "Instances", obj_card_selection);
}
