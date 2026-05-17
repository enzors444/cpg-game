draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _frame_operacao = -1;

switch (operacao) {
    case "+": _frame_operacao = 0; break;
    case "-": _frame_operacao = 1; break;
    case "*": _frame_operacao = 2; break;
    case "/": _frame_operacao = 3; break;
    case "(": _frame_operacao = 4; break;
    case ")": _frame_operacao = 5; break;
    case "=": _frame_operacao = 6; break;
    case "E": _frame_operacao = 7; break;
    case "R": _frame_operacao = 8; break;
}

var _draw_y = y + y_offset;
var _cor = c_white;

if (operacao == "R") {
    inicializar_roguelike();

    if (!variable_global_exists("cargas_reroll_mao")) global.cargas_reroll_mao = cargas_reroll_maximas();
    if (!variable_global_exists("fase_reroll_mao")) global.fase_reroll_mao = global.fase;

    if (global.fase_reroll_mao != global.fase) {
        global.fase_reroll_mao = global.fase;
        global.cargas_reroll_mao = cargas_reroll_maximas();
    }

    if (global.cargas_reroll_mao <= 0) {
        _cor = c_gray;
    }
}

if (_frame_operacao != -1 && _frame_operacao < sprite_get_number(spr_operations)) {
    var _escala = 0.75;
    var _w = 48;
    var _h = 48;

    draw_sprite_ext(spr_operations, _frame_operacao, x - _w / 2, _draw_y - _h / 2, _escala, _escala, 0, _cor, 1);

    if (operacao == "R") {
        draw_set_color(c_black);
        draw_text(x, _draw_y, string(global.cargas_reroll_mao));
    }

    exit;
}

draw_set_color(_cor);
draw_rectangle(x - 20, _draw_y - 20, x + 20, _draw_y + 20, false);
draw_set_color(c_black);
draw_text(x, _draw_y, string(operacao));

draw_set_halign(fa_left);
draw_set_valign(fa_top);
