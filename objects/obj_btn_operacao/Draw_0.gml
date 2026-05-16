draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _frame_operacao = -1;

switch (operacao) {
    case "+": _frame_operacao = 0; break;
    case "-": _frame_operacao = 1; break;
    case "*": _frame_operacao = 2; break;
    case "/": _frame_operacao = 3; break;
}

if (_frame_operacao != -1 && _frame_operacao < sprite_get_number(spr_operations)) {
    var _escala = 0.75;
    var _w = 48;
    var _h = 48;

    if (selecionada) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_white);
    }

    draw_rectangle(x - _w / 2, y - _h / 2, x + _w / 2, y + _h / 2, false);
    draw_sprite_ext(spr_operations, _frame_operacao, x - _w / 2, y - _h / 2, _escala, _escala, 0, c_white, 1);
    exit;
}

var _texto = operacao;
var _meia_largura = 20;
var _cor = selecionada ? c_yellow : c_white;

if (operacao == "REROLL") {
    inicializar_roguelike();

    if (!variable_global_exists("cargas_reroll_mao")) global.cargas_reroll_mao = cargas_reroll_maximas();
    if (!variable_global_exists("fase_reroll_mao")) global.fase_reroll_mao = global.fase;

    if (global.fase_reroll_mao != global.fase) {
        global.fase_reroll_mao = global.fase;
        global.cargas_reroll_mao = cargas_reroll_maximas();
    }

    _texto = "R" + string(global.cargas_reroll_mao);
    _meia_largura = 28;

    if (global.cargas_reroll_mao <= 0) {
        _cor = c_gray;
    }
}

if (operacao == "CLEAR") {
    _texto = "C";
    _meia_largura = 24;
}

draw_set_color(_cor);
draw_rectangle(x - _meia_largura, y - 20, x + _meia_largura, y + 20, false);
draw_set_color(c_black);
draw_text(x, y, _texto);
