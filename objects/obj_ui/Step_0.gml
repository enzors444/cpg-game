if (global.jogo_pausado) {
    exit;
}

if (!mouse_check_button_pressed(mb_left)) {
    exit;
}

var _btn_x = 8;
var _btn_w = 36;
var _btn_h = 42;
var _btn_y = room_height - 30 - _btn_h / 2;
var _painel_x = _btn_x;
var _painel_w = 178;
var _qtd = 0;

if (variable_global_exists("cartas_roguelike_escolhidas")) {
    _qtd = array_length(global.cartas_roguelike_escolhidas);
}

var _painel_h = 42 + max(1, _qtd) * 42;
var _painel_y = _btn_y - _painel_h - 6;

if (point_in_rectangle(mouse_x, mouse_y, _btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h)) {
    inventario_aberto = !inventario_aberto;
    exit;
}

if (inventario_aberto
&& !point_in_rectangle(mouse_x, mouse_y, _painel_x, _painel_y, _painel_x + _painel_w, _btn_y + _btn_h)) {
    inventario_aberto = false;
}
