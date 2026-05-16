// Create do obj_game
global.fase = 1;
global.tentativas = tentativas_base_fase();
global.bonus_tentativas_proxima = 0;
global.ui_tentativas = global.tentativas;
global.ui_top_space = 50;
global.inimigos_por_fase = 4;
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

resetar_roguelike();
inicializar_roguelike();
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
    var _start = room_width / 2 - (array_length(global.ops) * 50) / 2;

    for (var i = 0; i < array_length(global.ops); i++) {
        var _btn = instance_create_layer(_start + i * 50, 320 + global.ui_top_space, "Instances", obj_btn_operacao);
        _btn.operacao = global.ops[i];
    }

    var _btn_reroll = instance_create_layer(room_width - 40, 320 + global.ui_top_space, "Instances", obj_btn_operacao);
    _btn_reroll.operacao = "REROLL";

    var _btn_clear = instance_create_layer(room_width - 95, 320 + global.ui_top_space, "Instances", obj_btn_operacao);
    _btn_clear.operacao = "CLEAR";
};

criar_botoes_operacao();
