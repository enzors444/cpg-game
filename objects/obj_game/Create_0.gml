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