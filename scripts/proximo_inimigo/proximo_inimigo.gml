function tentativas_base_fase() {
    if (global.fase <= 1) return 4;
    if (global.fase == 2) return 4;
    return 5;
}

function boss_resetar_estado() {
    global.boss_ativo = false;
    global.boss_tipo = "";
    global.boss_nome = "";
    global.boss_estagio = 0;
    global.boss_vida_maxima = 0;
    global.boss_funcao_a = 1;
    global.boss_funcao_b = 0;
    global.boss_funcao_texto = "";
    global.boss_ultimo_x = "";
    global.boss_ultimo_dano = "";
    global.boss_mensagem = "";
}

function boss_maquina_linear_ativo() {
    return variable_global_exists("boss_ativo")
        && global.boss_ativo
        && global.boss_tipo == "maquina_linear";
}

function boss_maquina_linear_estagio_por_vida() {
    if (!boss_maquina_linear_ativo()) return 0;

    var _vida_maxima = max(1, global.boss_vida_maxima);
    if (global.enemy_life > _vida_maxima * 2 / 3) return 1;
    if (global.enemy_life > _vida_maxima / 3) return 2;
    return 3;
}

function boss_maquina_linear_atualizar_estagio() {
    if (!boss_maquina_linear_ativo()) return;

    global.boss_estagio = boss_maquina_linear_estagio_por_vida();

    switch (global.boss_estagio) {
        case 1:
            global.boss_funcao_a = 1;
            global.boss_funcao_b = 5;
            global.boss_funcao_texto = "f(x) = x + 5";
        break;

        case 2:
            global.boss_funcao_a = 2;
            global.boss_funcao_b = 1;
            global.boss_funcao_texto = "f(x) = 2x + 1";
        break;

        case 3:
            global.boss_funcao_a = 3;
            global.boss_funcao_b = -5;
            global.boss_funcao_texto = "f(x) = 3x - 5";
        break;
    }
}

function boss_maquina_linear_limite_estagio(_estagio) {
    var _vida_maxima = max(1, global.boss_vida_maxima);

    switch (_estagio) {
        case 1: return ceil(_vida_maxima * 2 / 3);
        case 2: return ceil(_vida_maxima / 3);
    }

    return 0;
}

function boss_maquina_linear_configurar() {
    global.boss_ativo = true;
    global.boss_tipo = "maquina_linear";
    global.boss_nome = "A Maquina Linear";
    global.boss_vida_maxima = global.enemy_life;
    global.boss_ultimo_x = "";
    global.boss_ultimo_dano = "";
    global.boss_mensagem = "Uma funcao acordou";

    boss_maquina_linear_atualizar_estagio();
}

function configurar_boss_atual() {
    boss_resetar_estado();

    var _indice = 0;
    var _total = 4;

    if (variable_global_exists("inimigo_atual_fase")) _indice = global.inimigo_atual_fase;
    if (variable_global_exists("inimigos_por_fase")) _total = global.inimigos_por_fase;

    var _boss = (_indice >= _total - 1);

    if (_boss && global.fase == 1) {
        boss_maquina_linear_configurar();
    }
}

function boss_maquina_linear_calcular_dano(_x) {
    boss_maquina_linear_atualizar_estagio();

    var _dano = global.boss_funcao_a * _x + global.boss_funcao_b;
    _dano = max(0, floor(_dano));

    global.boss_ultimo_x = _x;
    global.boss_ultimo_dano = _dano;
    global.boss_mensagem = "x = " + string(_x) + " vira dano " + string(_dano);

    return _dano;
}

function boss_maquina_linear_aplicar_limite_estagio(_vida_antes, _vida_depois) {
    var _estagio = global.boss_estagio;
    var _limite = boss_maquina_linear_limite_estagio(_estagio);

    if (_limite > 0 && _vida_antes > _limite && _vida_depois <= _limite) {
        global.boss_mensagem = "Estagio " + string(_estagio + 1) + " despertou";
        return _limite;
    }

    return _vida_depois;
}

function sortear_vida_inimigo() {
    var _indice = 0;
    var _total = 4;

    if (variable_global_exists("inimigo_atual_fase")) _indice = global.inimigo_atual_fase;
    if (variable_global_exists("inimigos_por_fase")) _total = global.inimigos_por_fase;

    var _boss = (_indice >= _total - 1);

    switch (global.fase) {
        case 1:
            if (_boss) return irandom_range(70, 90);
            if (_indice <= 0) return irandom_range(10, 18);
            return irandom_range(16, 28);

        case 2:
            if (_boss) return irandom_range(430, 650);
            return irandom_range(100 + _indice * 90, 180 + _indice * 100);

        case 3:
            if (_boss) return irandom_range(3600, 5200);
            return irandom_range(1000 + _indice * 650, 1600 + _indice * 750);
    }

    return irandom_range(10, 25);
}

function criar_inimigos() {
    global.enemy_life = sortear_vida_inimigo();
    configurar_boss_atual();

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
