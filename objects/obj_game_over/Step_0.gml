if (variable_global_exists("renzo_game_over_ativo") && global.renzo_game_over_ativo) {
    global.renzo_game_over_timer += 1;

    if (global.renzo_game_over_timer >= global.renzo_game_over_duracao) {
        global.renzo_game_over_ativo = false;
        resposta = "";
        keyboard_string = "";
        game_over_iniciar_desafio();
    }

    exit;
}

if (!variable_global_exists("game_over_ativo") || !global.game_over_ativo) {
    instance_destroy();
    exit;
}

keyboard_string = game_over_filtrar_resposta(keyboard_string);
resposta = keyboard_string;

global.game_over_timer -= 1;

var _panel_w = 360;
var _panel_h = 250;
var _panel_x1 = room_width / 2 - _panel_w / 2;
var _panel_y1 = room_height / 2 - _panel_h / 2;
var _btn_x1 = _panel_x1 + _panel_w - 132;
var _btn_y1 = _panel_y1 + _panel_h - 48;
var _btn_x2 = _btn_x1 + 96;
var _btn_y2 = _btn_y1 + 30;
var _clicou_responder = mouse_check_button_pressed(mb_left)
    && point_in_rectangle(mouse_x, mouse_y, _btn_x1, _btn_y1, _btn_x2, _btn_y2);
var _confirmou = keyboard_check_pressed(vk_enter) || _clicou_responder;

if (_confirmou) {
    if (resposta != "" && real(resposta) == global.game_over_resposta) {
        game_over_acertar();
        instance_destroy();
    } else {
        game_over_falhar();
    }

    exit;
}

if (global.game_over_timer <= 0) {
    game_over_falhar();
}
