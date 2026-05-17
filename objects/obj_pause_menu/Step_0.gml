if (!variable_global_exists("pause_ativo") || !global.pause_ativo) {
    instance_destroy();
    exit;
}

pause_hover = -1;

var _btn_w = 220;
var _btn_h = 34;
var _gap = 13;
var _panel_h = 245;
var _start_y = room_height / 2 - _panel_h / 2 + 82;
var _x1 = room_width / 2 - _btn_w / 2;
var _acao = "";

for (var i = 0; i < array_length(pause_botoes); i++) {
    var _y1 = _start_y + i * (_btn_h + _gap);
    var _x2 = _x1 + _btn_w;
    var _y2 = _y1 + _btn_h;

    if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)) {
        pause_hover = i;

        if (mouse_check_button_pressed(mb_left)) {
            _acao = pause_botoes[i].acao;
        }
    }
}

if (_acao == "" && keyboard_check_pressed(vk_escape)) {
    _acao = "continuar";
}

switch (_acao) {
    case "continuar":
        with (obj_enemy) {
            if (variable_instance_exists(id, "pause_image_speed")) image_speed = pause_image_speed;
        }

        with (obj_player) {
            if (variable_instance_exists(id, "pause_image_speed")) image_speed = pause_image_speed;
        }

        with (obj_critical) {
            if (variable_instance_exists(id, "pause_image_speed")) image_speed = pause_image_speed;
        }

        global.pause_ativo = false;
        global.jogo_pausado = false;
        instance_destroy();
        break;

    case "menu":
        global.pause_ativo = false;
        global.jogo_pausado = false;
        parar_musica();
        room_goto(RoomMenu);
        break;

    case "sair":
        game_end();
        break;
}
