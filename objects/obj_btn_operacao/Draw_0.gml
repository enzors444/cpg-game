draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _texto = operacao;
var _meia_largura = 20;
var _cor = selecionada ? c_yellow : c_white;

if (operacao == "REROLL") {
    if (!variable_global_exists("cargas_reroll_mao")) global.cargas_reroll_mao = 2;
    if (!variable_global_exists("fase_reroll_mao")) global.fase_reroll_mao = global.fase;

    if (global.fase_reroll_mao != global.fase) {
        global.fase_reroll_mao = global.fase;
        global.cargas_reroll_mao = 2;
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
