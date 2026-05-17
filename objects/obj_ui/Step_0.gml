var _btn_x = 8;
var _btn_w = 48;
var _btn_h = 48;
var _btn_y = room_height - 30 - _btn_h / 2;
var _card_w = 48;
var _card_h = 64;
var _card_gap = 8;
var _qtd = 0;

if (variable_global_exists("cartas_roguelike_escolhidas")) {
    _qtd = array_length(global.cartas_roguelike_escolhidas);
}

inventario_hover = !global.jogo_pausado
    && point_in_rectangle(mouse_x, mouse_y, _btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h);

var _alvo = inventario_hover ? -12 : 0;
inventario_y_offset = lerp(inventario_y_offset, _alvo, 0.2);
var _btn_draw_y = _btn_y + inventario_y_offset;

var _stack_h = _qtd * _card_h + max(0, _qtd - 1) * _card_gap;
var _stack_x1 = _btn_x;
var _stack_x2 = _btn_x + _card_w;
var _stack_y2 = _btn_draw_y - _card_gap;
var _stack_y1 = _stack_y2 - _stack_h;

if (global.jogo_pausado || !mouse_check_button_pressed(mb_left)) {
    exit;
}

if (inventario_hover) {
    inventario_aberto = !inventario_aberto;
    exit;
}

if (inventario_aberto
&& !point_in_rectangle(mouse_x, mouse_y, _stack_x1, _stack_y1, _stack_x2, _btn_draw_y + _btn_h)) {
    inventario_aberto = false;
}
