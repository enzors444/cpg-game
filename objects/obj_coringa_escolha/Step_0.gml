if (!global.coringa_escolhendo_valor) {
    instance_destroy();
    exit;
}

if (!mouse_check_button_pressed(mb_left)) {
    exit;
}

var _cols = 5;
var _tam = 32;
var _gap = 8;
var _total_w = _cols * _tam + (_cols - 1) * _gap;
var _start_x = room_width / 2 - _total_w / 2;
var _start_y = 160;

for (var n = 0; n <= 9; n++) {
    var _col = n mod _cols;
    var _row = floor(n / _cols);
    var _x = _start_x + _col * (_tam + _gap);
    var _y = _start_y + _row * (_tam + _gap);

    if (point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + _tam, _y + _tam)) {
        if (indice_expressao >= 0 && indice_expressao < array_length(global.expressao_partes)) {
            global.expressao_partes[indice_expressao].valor = n;
            global.expressao_partes[indice_expressao].coringa = true;
        }

        var _idx = array_get_index(global.indices_cartas_selecionadas, indice_mao);
        if (_idx != -1) {
            global.cartas_selecionadas[_idx] = n;
        }

        var _hand = instance_find(obj_hand, 0);
        if (_hand != noone && indice_mao >= 0 && indice_mao < array_length(_hand.mao)) {
            if (!variable_instance_exists(_hand, "mao_coringa")) {
                _hand.mao_coringa = [];
            }

            while (array_length(_hand.mao_coringa) < array_length(_hand.mao)) {
                array_push(_hand.mao_coringa, false);
            }

            _hand.mao[indice_mao] = n;
            _hand.mao_coringa[indice_mao] = true;
        }

        with (obj_carta) {
            if (!carta_selecao && indice_mao == other.indice_mao) {
                numero = n;
                image_index = n;
                coringa_numerico = true;
                image_blend = c_aqua;
            }
        }

        global.usos_coringa_numerico_rodada += 1;
        global.coringa_escolhendo_valor = false;
        global.jogo_pausado = false;
        instance_destroy();
        exit;
    }
}
