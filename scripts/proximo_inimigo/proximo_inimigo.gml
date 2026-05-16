function tentativas_base_fase() {
    if (global.fase <= 1) return 4;
    return 3;
}

function sortear_vida_inimigo() {
    var _indice = 0;
    var _total = 4;

    if (variable_global_exists("inimigo_atual_fase")) _indice = global.inimigo_atual_fase;
    if (variable_global_exists("inimigos_por_fase")) _total = global.inimigos_por_fase;

    var _boss = (_indice >= _total - 1);

    switch (global.fase) {
        case 1:
            if (_boss) return irandom_range(30, 45);
            if (_indice <= 0) return irandom_range(10, 18);
            return irandom_range(16, 28);

        case 2:
            if (_boss) return irandom_range(90, 160);
            return irandom_range(35 + _indice * 10, 80 + _indice * 15);

        case 3:
            if (_boss) return irandom_range(160, 280);
            return irandom_range(60 + _indice * 20, 140 + _indice * 30);
    }

    return irandom_range(10, 25);
}

function criar_inimigos() {
    global.enemy_life = sortear_vida_inimigo();

    var _qtd_inimigos = global.fase + 1;
    var _base_x = 2 * room_width / 3;
    var _gap = 40;

    for (var i = 0; i < _qtd_inimigos; i++) {
        var _peso = power(10, i);
        var _numero = floor(global.enemy_life / _peso) mod 10;

        var _enemy = instance_create_layer(_base_x - i * _gap, 100 + global.ui_top_space, "Instances", obj_enemy);
        _enemy.definir_numero_enemy(_numero, i);
        _enemy.visible = (i == 0 || global.enemy_life >= _peso);
    }
}

function proximo_inimigo() {
    with (obj_enemy) {
        instance_destroy();
    }

    inicializar_roguelike();

    if (!variable_global_exists("inimigos_por_fase")) global.inimigos_por_fase = 4;
    if (!variable_global_exists("inimigo_atual_fase")) global.inimigo_atual_fase = 0;
    if (!variable_global_exists("fase_maxima")) global.fase_maxima = 3;

    var _mudou_fase = false;

    global.inimigo_atual_fase++;

    if (global.inimigo_atual_fase >= global.inimigos_por_fase) {
        global.inimigo_atual_fase = 0;
        limpar_bonus_temporarios_fase();

        if (global.fase < global.fase_maxima) {
            global.fase++;
            global.precisa_atualizar_botoes = true;
            _mudou_fase = true;
        }
    }

    resetar_roguelike_por_rodada();

    global.tentativas = tentativas_base_fase() + global.bonus_tentativas_proxima;
    global.bonus_tentativas_proxima = 0;
    global.ui_tentativas = global.tentativas;
    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];

    criar_inimigos();

    if (_mudou_fase) {
        abrir_recompensa_roguelike();
    }
}
