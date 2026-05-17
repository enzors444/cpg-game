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

// --- AJUSTE DE POSIÇÃO APENAS PARA R E E ---
var _draw_x = x;
var _draw_y = y + y_offset;
var _cor = c_white;

// Se for o Reroll ou a Borracha, joga eles para o canto inferior direito
if (operacao == "R" || operacao == "E") {
    // Define a posição do canto da tela (com uma margem de 50 pixels)
    _draw_x = room_width - 35; 
    
    if (operacao == "R") {
        // Reroll fica mais para cima (margem de 110 pixels do fundo)
        _draw_y = (room_height - 95) + y_offset; 
        
        // Sua lógica original do Reroll (mantida intacta)
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
    else if (operacao == "E") {
        // Borracha fica logo abaixo do Reroll (margem de 50 pixels do fundo)
        _draw_y = y + y_offset;
    }
}
// -------------------------------------------

if (_frame_operacao != -1 && _frame_operacao < sprite_get_number(spr_operations)) {
    var _escala = 0.75;
    var _w = 48;
    var _h = 48;
    
    // Agora usa as novas variáveis _draw_x e _draw_y que calculamos acima
    if(operacao != "R" && operacao != "E"){
        draw_sprite_ext(spr_operations, _frame_operacao, _draw_x - _w / 2, _draw_y - _h / 2, _escala, _escala, 0, _cor, 1);
    }
    else if(operacao == "E"){
        draw_sprite_ext(spr_operations, _frame_operacao, _draw_x - _w / 2, _draw_y - _h / 2, _escala, _escala, 0, _cor, 1);
    }
    else if(operacao == "R"){
        draw_sprite_ext(spr_operations, _frame_operacao, _draw_x - _w / 2, _draw_y - _h / 2, _escala, _escala, 0, _cor, 1);
    }
    exit;
}

draw_set_color(_cor);
draw_rectangle(_draw_x - 20, _draw_y - 20, _draw_x + 20, _draw_y + 20, false);
draw_set_color(c_black);
draw_text(_draw_x, _draw_y, string(operacao));

draw_set_halign(fa_left);
draw_set_valign(fa_top);