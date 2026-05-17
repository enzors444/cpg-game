depth = -100000;
pause_hover = -1;
pause_botoes = [
    { texto: "CONTINUAR", acao: "continuar" },
    { texto: "MENU PRINCIPAL", acao: "menu" },
    { texto: "SAIR", acao: "sair" }
];

with (obj_enemy) {
    pause_image_speed = image_speed;
    image_speed = 0;
}

with (obj_player) {
    pause_image_speed = image_speed;
    image_speed = 0;
}

with (obj_critical) {
    pause_image_speed = image_speed;
    image_speed = 0;
}
