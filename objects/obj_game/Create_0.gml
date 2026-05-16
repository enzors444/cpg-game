// Create do obj_game
global.fase                = 1;
global.tentativas          = 3;
global.bonus_tentativas_proxima = 0;
global.cargas_reroll_mao   = 2;
global.fase_reroll_mao     = global.fase;
global.carta_escolhida     = -1;
global.jogo_pausado        = false;
global.mao                 = [];
global.cartas_selecionadas = [];
global.indices_cartas_selecionadas = [];
global.ops_selecionadas    = [];

var _position = 0;
for (var i = 0; i < (global.fase + 1); i++) {
instance_create_layer(2 * room_width / 3 - _position , 100, "Instances", obj_enemy);
_position = 40;
if(i == 0){
	global.enemy_life += global.chosen_enemy;
}
else if(i == 1){
	global.enemy_life += global.chosen_enemy * 10;
}
else if(i == 2){
	global.enemy_life += global.chosen_enemy * 100;
}
}
instance_create_layer(0, 0, "Instances", obj_hand);

// botões de operação
global.ops  = operacoes_da_fase();
var _start  = room_width/2 - (array_length(global.ops) * 50) / 2;
for (var i = 0; i < array_length(global.ops); i++) {
    var _btn      = instance_create_layer(_start + i * 50, 270, "Instances", obj_btn_operacao);
    _btn.operacao = global.ops[i];
}

var _btn_reroll      = instance_create_layer(room_width - 40, 270, "Instances", obj_btn_operacao);
_btn_reroll.operacao = "REROLL";