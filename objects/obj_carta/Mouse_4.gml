// só seleciona se ainda não foi selecionada
if (!selecionada) {
    selecionada = true;
    array_push(global.cartas_selecionadas, numero);
    image_blend = c_yellow; // feedback visual de selecionada
} else {
    // clicou de novo = deseleciona
    selecionada = false;
    var _idx = array_get_index(global.cartas_selecionadas, numero);
    array_delete(global.cartas_selecionadas, _idx, 1);
    image_blend = c_white;
}