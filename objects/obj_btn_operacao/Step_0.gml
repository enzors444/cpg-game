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
    case "R":
}

// --- CORREÇÃO DA POSIÇÃO DE HOVER ---
// Cria variáveis espelho para saber onde o botão realmente está na tela
var _check_x = x;
var _check_y = y;

// Se for R ou E, substitui a posição pela nova posição do cantinho
if (operacao == "R" || operacao == "E") {
    _check_x = room_width - 40; 
    
    if (operacao == "R") {
        _check_y = room_height - 90; 
    } 
    else if (operacao == "E") {
        _check_y = y; // O 'E' continuou na altura Y padrão no Draw
    }
}
// -------------------------------------

// Agora usamos o _check_x e _check_y no lugar do x e y originais!
hover = point_in_rectangle(mouse_x, mouse_y, _check_x - _meia_largura, _check_y - _meia_altura, _check_x + _meia_largura, _check_y + _meia_altura);

var _alvo = (hover || selecionada) ? -12 : 0;
y_offset = lerp(y_offset, _alvo, 0.2);

if (mouse_check_button_pressed(mb_left) && hover) {
    event_perform(ev_mouse, ev_left_press);
}