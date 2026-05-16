sprites_enemy = [
    spr_enemy_0,
	spr_enemy_1,
	spr_enemy_2,
	spr_enemy_3,
	spr_enemy_4,
	spr_enemy_5,
	spr_enemy_6,
	spr_enemy_7,
	spr_enemy_8,
	spr_enemy_9
];

definir_numero_enemy = function(_numero, _posicao) {
    digito_posicao = _posicao;
    numero_enemy = _numero;
    sprite_index = sprites_enemy[numero_enemy];
    image_index = 0;
    image_speed = 0;
};

definir_numero_enemy(irandom(9), 0);
