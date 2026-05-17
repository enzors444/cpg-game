if ((variable_global_exists("pause_ativo") && global.pause_ativo)
|| (variable_global_exists("admin_menu_ativo") && global.admin_menu_ativo)) {
    exit;
}

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

if (enemy_estado == "aparecendo" || enemy_estado == "morrendo") {
    enemy_anim_timer++;

    if (enemy_anim_timer >= enemy_anim_duration) {
        if (enemy_estado == "aparecendo") {
            enemy_ir_para_parado();
        } else if (enemy_morte_proximo) {
            image_index = image_number - 1;
            image_speed = 0;
            enemy_morte_concluida = true;
            verificar_morte_numeros_finalizada();
        } else {
            ocultar_numero_enemy();
        }
    }

    if (enemy_estado == "morrendo") exit;
}

var _peso = power(10, digito_posicao);
var _numero_atual = floor(global.enemy_life / _peso) mod 10;
var _visivel_atual = (digito_posicao == 0 || global.enemy_life >= _peso);

atualizar_numero_enemy(_numero_atual, _visivel_atual);
