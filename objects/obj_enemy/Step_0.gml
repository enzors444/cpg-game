var _peso = power(10, digito_posicao);
var _numero_atual = floor(global.enemy_life / _peso) mod 10;

definir_numero_enemy(_numero_atual, digito_posicao);
visible = (digito_posicao == 0 || global.enemy_life >= _peso);
