scroll_cenario += 1.1;
anim_player += 0.16;
anim_professor += 0.08;

var _caixa_margem_tela = 2;
var _arena_w = 600;
var _arena_x1 = room_width / 2 - _arena_w / 2;
var _arena_x2 = room_width / 2 + _arena_w / 2;
var _caixa_x2 = min(room_width - _caixa_margem_tela, _arena_x2);
var _ok_x1 = _caixa_x2 - 84;
var _ok_y1 = room_height - 24 - 58;
var _ok_x2 = _ok_x1 + 64;
var _ok_y2 = _ok_y1 + 28;

if (transicao) {
    transicao_timer += 1;

    if (transicao_timer >= 95) {
        room_goto(Room1);
    }

    exit;
}

var _clicou_ok = mouse_check_button_pressed(mb_left)
    && point_in_rectangle(mouse_x, mouse_y, _ok_x1, _ok_y1, _ok_x2, _ok_y2);
var _confirmou = _clicou_ok
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space);

if (_confirmou) {
    dialogo_atual += 1;

    if (dialogo_atual >= array_length(dialogos)) {
        transicao = true;
        transicao_timer = 0;
    }
}
