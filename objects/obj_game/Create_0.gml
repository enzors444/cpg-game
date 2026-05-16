// Create do obj_game
global.fase                = 1;
global.tentativas          = 3;
global.carta_escolhida     = -1;
global.jogo_pausado        = false;
global.mao                 = [];
global.cartas_selecionadas = [];
global.ops_selecionadas    = [];

instance_create_layer(room_width/2, room_height/2, "Instances", obj_enemy);
instance_create_layer(0, 0, "Instances", obj_hand);

// botões de operação
global.ops  = operacoes_da_fase();
var _start  = room_width/2 - (array_length(global.ops) * 50) / 2;
for (var i = 0; i < array_length(global.ops); i++) {
    var _btn      = instance_create_layer(_start + i * 50, 150, "Instances", obj_btn_operacao);
    _btn.operacao = global.ops[i];
}