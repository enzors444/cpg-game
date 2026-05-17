scroll_cenario += 1.1;
anim_player += 0.16;
anim_professor += 0.08;

var _caixa_margem_tela = 2;
var _arena_w = 600;
var _arena_x1 = room_width / 2 - _arena_w / 2;
var _arena_x2 = room_width / 2 + _arena_w / 2;
var _caixa_x2 = min(room_width - _caixa_margem_tela, _arena_x2);
var _ok_x1 = _caixa_x2 - 84;
var _ok_y1 = room_height - 24 - 40;
var _ok_x2 = _ok_x1 + 64;
var _ok_y2 = _ok_y1 + 28;
var _dialogo_texto = dialogos[min(dialogo_atual, array_length(dialogos) - 1)];
var _dialogo_tamanho = string_length(_dialogo_texto);

if (!transicao && texto_revelado < _dialogo_tamanho) {
    texto_timer += texto_velocidade;
    texto_revelado = min(_dialogo_tamanho, floor(texto_timer));

    if (!dialogo_som_tocando) {
        tocar_sfx_loop_unico("dialogo", dialogo, 1.4);
        dialogo_som_tocando = true;
    }

    if (texto_revelado >= _dialogo_tamanho) {
        parar_sfx_unico("dialogo");
        dialogo_som_tocando = false;
    }
}

if (transicao) {
    parar_sfx_unico("dialogo");
    dialogo_som_tocando = false;
    transicao_timer += 1;

    if (transicao_timer >= 95) {
        room_goto(Room1);
    }

    exit;
}

var _clicou_ok = mouse_check_button_pressed(mb_left)
    && point_in_rectangle(mouse_x, mouse_y, _ok_x1, _ok_y1, _ok_x2, _ok_y2);
var _confirmou = _clicou_ok
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space);

if (_confirmou) {
    if (texto_revelado < _dialogo_tamanho) {
        texto_revelado = _dialogo_tamanho;
        texto_timer = _dialogo_tamanho;
        parar_sfx_unico("dialogo");
        dialogo_som_tocando = false;
        exit;
    }

    dialogo_atual += 1;

    if (dialogo_atual >= array_length(dialogos)) {
        parar_sfx_unico("dialogo");
        dialogo_som_tocando = false;
        transicao = true;
        transicao_timer = 0;
    } else {
        texto_revelado = 0;
        texto_timer = 0;
        tocar_sfx_loop_unico("dialogo", dialogo, 1.4);
        dialogo_som_tocando = true;
    }
}
