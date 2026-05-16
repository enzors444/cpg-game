if (!mouse_check_button_pressed(mb_left)) {
    exit;
}

var _meia_largura = 20;
var _meia_altura = 20;

switch (operacao) {
    case "+":
    case "-":
    case "*":
    case "/":
        _meia_largura = 24;
        _meia_altura = 24;
        break;

    case "REROLL":
        _meia_largura = 28;
        break;

    case "CLEAR":
        _meia_largura = 24;
        break;
}

if (point_in_rectangle(mouse_x, mouse_y, x - _meia_largura, y - _meia_altura, x + _meia_largura, y + _meia_altura)) {
    event_perform(ev_mouse, ev_left_press);
}
