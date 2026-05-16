function proximo_inimigo() {
    global.tentativas = 3;
    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_enemy);
}
