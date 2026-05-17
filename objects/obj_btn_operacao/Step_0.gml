if (variable_global_exists("pause_ativo") && global.pause_ativo) {
    exit;
}

var _meia_largura = 24;
var _meia_altura = 24;

hover = point_in_rectangle(mouse_x, mouse_y, x - _meia_largura, y - _meia_altura, x + _meia_largura, y + _meia_altura);

var _hover_visual = hover && operacao != "R" && operacao != "E";
var _alvo = (_hover_visual || selecionada) ? -12 : 0;
y_offset = lerp(y_offset, _alvo, 0.2);

if (mouse_check_button_pressed(mb_left) && hover) {
    clique_manual_operacao = true;
    event_perform(ev_mouse, ev_left_press);
}
