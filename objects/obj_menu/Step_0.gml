menu_anim_player += 0.12;
menu_hover = -1;

var _menu_w = sprite_get_width(spr_menu);
var _menu_h = sprite_get_height(spr_menu);
var _menu_scale = max(room_width / _menu_w, room_height / _menu_h);
var _menu_x = room_width / 2 - (_menu_w * _menu_scale) / 2;
var _menu_y = room_height / 2 - (_menu_h * _menu_scale) / 2;

if (menu_tela == "creditos") {
    var _voltar_x1 = _menu_x + 24 * _menu_scale;
    var _voltar_y1 = _menu_y + 276 * _menu_scale;
    var _voltar_x2 = _voltar_x1 + 92 * _menu_scale;
    var _voltar_y2 = _voltar_y1 + 28 * _menu_scale;
    var _clicou_voltar = mouse_check_button_pressed(mb_left)
        && point_in_rectangle(mouse_x, mouse_y, _voltar_x1, _voltar_y1, _voltar_x2, _voltar_y2);

    if (_clicou_voltar || keyboard_check_pressed(vk_escape)) {
        menu_tela = "principal";
    }

    exit;
}

for (var i = 0; i < array_length(menu_botoes); i++) {
    var _botao = menu_botoes[i];
    var _x1 = _menu_x + _botao.rx * _menu_scale;
    var _y1 = _menu_y + _botao.ry * _menu_scale;
    var _x2 = _x1 + _botao.w * _menu_scale;
    var _y2 = _y1 + _botao.h * _menu_scale;

    if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)) {
        menu_hover = i;

        if (mouse_check_button_pressed(mb_left)) {
            switch (_botao.acao) {
                case "jogar":
                    room_goto(RoomTutorial);
                    break;

                case "creditos":
                    menu_tela = "creditos";
                    break;

                case "sair":
                    game_end();
                    break;
            }
        }
    }
}
