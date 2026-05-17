if (!variable_global_exists("admin_menu_ativo") || !global.admin_menu_ativo) {
    instance_destroy();
    exit;
}

admin_hover = -1;

if (admin_feedback_timer > 0) {
    admin_feedback_timer--;
}

var _combo_admin = keyboard_check(vk_control)
    && keyboard_check(vk_shift)
    && keyboard_check_pressed(ord("A"));
var _acao = "";
var _btn_w = 132;
var _btn_h = 28;
var _gap_x = 12;
var _gap_y = 9;
var _panel_w = 336;
var _panel_h = 250;
var _panel_x1 = room_width / 2 - _panel_w / 2;
var _panel_y1 = room_height / 2 - _panel_h / 2;
var _grid_x = room_width / 2 - (_btn_w * 2 + _gap_x) / 2;
var _start_y = _panel_y1 + 58;

for (var i = 0; i < array_length(admin_botoes); i++) {
    var _botao = admin_botoes[i];
    var _full = _botao.acao == "comprar" || _botao.acao == "fechar";
    var _x1 = _full ? room_width / 2 - (_btn_w * 2 + _gap_x) / 2 : _grid_x + _botao.coluna * (_btn_w + _gap_x);
    var _y1 = _start_y + _botao.linha * (_btn_h + _gap_y);
    var _x2 = _full ? room_width / 2 + (_btn_w * 2 + _gap_x) / 2 : _x1 + _btn_w;
    var _y2 = _y1 + _btn_h;

    if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)) {
        admin_hover = i;

        if (mouse_check_button_pressed(mb_left)) {
            _acao = _botao.acao;
        }
    }
}

if (_acao == "" && (keyboard_check_pressed(vk_escape) || _combo_admin)) {
    _acao = "fechar";
}

switch (_acao) {
    case "fase1":
        admin_ir_para(1, false);
        break;

    case "boss1":
        admin_ir_para(1, true);
        break;

    case "fase2":
        admin_ir_para(2, false);
        break;

    case "boss2":
        admin_ir_para(2, true);
        break;

    case "fase3":
        admin_ir_para(3, false);
        break;

    case "boss3":
        admin_ir_para(3, true);
        break;

    case "comprar":
        admin_comprar_todas();
        break;

    case "fechar":
        admin_fechar();
        break;
}
