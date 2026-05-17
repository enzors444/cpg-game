// Create do obj_game
var _fase_da_sala = fase_da_sala_atual();
var _nova_run = (_fase_da_sala == 1);

global.fase = _fase_da_sala;

if (_nova_run) {
    resetar_roguelike();
}

inicializar_roguelike();

if (!variable_global_exists("bonus_tentativas_proxima") || _nova_run) {
    global.bonus_tentativas_proxima = 0;
}

global.tentativas = tentativas_base_fase() + global.bonus_tentativas_proxima;
global.bonus_tentativas_proxima = 0;
global.ui_tentativas = global.tentativas;
global.ui_top_space = 50;
global.inimigos_por_fase = encontros_combate_da_fase(global.fase);
global.inimigo_atual_fase = 0;
global.fase_maxima = 3;
global.precisa_atualizar_botoes = false;
global.cargas_reroll_mao = 2;
global.fase_reroll_mao = global.fase;
global.carta_escolhida = -1;
global.jogo_pausado = false;
global.mao = [];
global.cartas_selecionadas = [];
global.indices_cartas_selecionadas = [];
global.ops_selecionadas = [];
global.expressao_partes = [];

global.cargas_reroll_mao = cargas_reroll_maximas();

criar_inimigos();

instance_create_layer(room_width / 3, 100 + global.ui_top_space, "Instances", obj_player);
instance_create_layer(0, 0, "Instances", obj_hand);
instance_create_layer(0, 0, "Instances", obj_ui);

criar_botoes_operacao = function() {
    with (obj_btn_operacao) {
        instance_destroy();
    }

    global.ops = operacoes_da_fase();
    var _botoes = [];

    for (var i = 0; i < array_length(global.ops); i++) {
        array_push(_botoes, global.ops[i]);
    }

    array_push(_botoes, "E");
    array_push(_botoes, "R");

    var _qtd_botoes = array_length(_botoes);
    var _linha_y = room_height - 30;
    var _limite_esq = 80;
    var _limite_dir = room_width - 30;
    var _gap = 54;

    if (_qtd_botoes > 1) {
        _gap = min(_gap, (_limite_dir - _limite_esq) / (_qtd_botoes - 1));
    }

    var _largura_total = max(0, _qtd_botoes - 1) * _gap;
    var _start = (_limite_esq + _limite_dir) / 2 - _largura_total / 2;

    for (var j = 0; j < _qtd_botoes; j++) {
        var _btn = instance_create_layer(_start + j * _gap, _linha_y, "Instances", obj_btn_operacao);
        _btn.operacao = _botoes[j];
    }
};

criar_botoes_operacao();
