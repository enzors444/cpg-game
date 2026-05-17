tela_final_anim += 0.08;
tela_final_hover = -1;

var _acao = "";
var _qtd = array_length(tela_final_botoes);
var _botao_w = 230;
var _botao_h = 62;
var _margem_botao = 24;
var _y1 = room_height - 94;

for (var i = 0; i < _qtd; i++) {
    var _x1 = room_width / 2 - _botao_w / 2;

    if (_qtd > 1) {
        _x1 = (i == 0) ? _margem_botao : room_width - _margem_botao - _botao_w;
    }

    var _x2 = _x1 + _botao_w;
    var _y2 = _y1 + _botao_h;

    if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)) {
        tela_final_hover = i;

        if (mouse_check_button_pressed(mb_left)) {
            _acao = tela_final_botoes[i].acao;
        }
    }
}

if (_acao == "" && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))) {
    _acao = tela_final_botoes[0].acao;
}

if (keyboard_check_pressed(vk_escape)) {
    _acao = "menu";
}

switch (_acao) {
    case "tentar":
        global.jogo_pausado = false;
        global.jogo_vencido = false;

        var _sala = Room1;

        if (variable_global_exists("game_over_reiniciar_sala")) {
            _sala = global.game_over_reiniciar_sala;
        }

        room_goto(_sala);
        break;

    case "jogar":
        global.jogo_pausado = false;
        global.jogo_vencido = false;
        global.game_over_nivel = 0;
        room_goto(RoomTutorial);
        break;

    case "menu":
        global.jogo_pausado = false;
        global.jogo_vencido = false;
        room_goto(RoomMenu);
        break;
}
