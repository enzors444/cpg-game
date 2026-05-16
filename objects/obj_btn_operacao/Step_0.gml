var _meia_largura = 20;
var _meia_altura = 20;

switch (operacao) {
    case "+":
    case "-":
    case "*":
    case "/":
    case "(":
    case ")":
    case "=":
    case "E":
    case "CLEAR":
        _meia_largura = 24;
        _meia_altura = 24;
        break;

    case "R":
    case "REROLL":
        _meia_largura = 28;
        _meia_altura = 24;
        break;
}

hover = point_in_rectangle(mouse_x, mouse_y, x - _meia_largura, y - _meia_altura, x + _meia_largura, y + _meia_altura);

var _alvo = (hover || selecionada) ? -12 : 0;
y_offset = lerp(y_offset, _alvo, 0.2);

if (mouse_check_button_pressed(mb_left) && hover) {
    event_perform(ev_mouse, ev_left_press);
}
