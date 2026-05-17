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

boss_visual = false;
boss_fase = 0;
boss_estagio_visual = 0;

definir_numero_enemy = function(_numero, _posicao) {
    boss_visual = false;
    digito_posicao = _posicao;
    numero_enemy = _numero;
    sprite_index = sprites_enemy[numero_enemy];
};

definir_boss_enemy = function(_fase, _estagio) {
    boss_visual = true;
    boss_fase = _fase;
    boss_estagio_visual = _estagio;
    digito_posicao = 0;
    numero_enemy = 0;
    sprite_index = sprite_boss_da_fase(boss_fase, boss_estagio_visual);
    image_index = 0;
    image_speed = 0.12;
};

definir_numero_enemy(irandom(9), 0);
