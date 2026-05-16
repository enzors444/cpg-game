if (!global.recompensa_roguelike_aberta) {
    instance_destroy();
    exit;
}

if (!mouse_check_button_pressed(mb_left)) {
    exit;
}

var _w = 150;
var _h = 205;
var _gap = 10;
var _qtd = array_length(global.roguelike_opcoes);
var _total_w = _qtd * _w + max(0, _qtd - 1) * _gap;
var _start_x = room_width / 2 - _total_w / 2;
var _y = 76;

for (var i = 0; i < _qtd; i++) {
    var _x = _start_x + i * (_w + _gap);

    if (point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + _w, _y + _h)) {
        aplicar_carta_roguelike(global.roguelike_opcoes[i]);
        fechar_recompensa_roguelike();
        exit;
    }
}
