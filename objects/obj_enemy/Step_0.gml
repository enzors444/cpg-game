if (boss_visual) {
    var _estagio_atual = boss_estagio_visual;

    if (variable_global_exists("boss_estagio") && global.boss_estagio > 0) {
        _estagio_atual = global.boss_estagio;
    }

    var _sprite_boss = sprite_boss_da_fase(boss_fase, _estagio_atual);

    if (sprite_index != _sprite_boss) {
        boss_estagio_visual = _estagio_atual;
        sprite_index = _sprite_boss;
        image_index = 0;
    }

    visible = true;
    exit;
}

var _peso = power(10, digito_posicao);
var _numero_atual = floor(global.enemy_life / _peso) mod 10;

definir_numero_enemy(_numero_atual, digito_posicao);
visible = (digito_posicao == 0 || global.enemy_life >= _peso);
