function tentativas_base_fase() {
    if (global.fase <= 1) return 4;
    if (global.fase == 2) return 4;
    return 5;
}

function fase_da_sala_atual() {
    var _nome_sala = room_get_name(room);

    switch (_nome_sala) {
        case "Room1": return 1;
        case "Room2": return 2;
        case "Room3": return 3;
    }

    return 1;
}

function sala_da_fase(_fase) {
    switch (_fase) {
        case 1: return Room1;
        case 2: return Room2;
        case 3: return Room3;
    }

    return Room1;
}

function sprite_arena_da_fase(_fase) {
    var _nome_sprite = "spr_arena_room" + string(_fase);
    var _sprite = asset_get_index(_nome_sprite);

    if (_sprite != -1) {
        return _sprite;
    }

    return spr_background;
}

function encontros_combate_da_fase(_fase) {
    switch (_fase) {
        case 1: return 4;
        case 2: return 5;
        case 3: return 6;
    }

    return 4;
}

function indice_boss_da_fase(_fase) {
    return encontros_combate_da_fase(_fase) - 1;
}

function encontro_atual_e_boss() {
    if (!variable_global_exists("fase")) return false;
    if (!variable_global_exists("inimigo_atual_fase")) return false;

    return global.inimigo_atual_fase >= indice_boss_da_fase(global.fase);
}

function recompensa_apos_encontro(_fase, _indice_derrotado) {
    switch (_fase) {
        case 1: return _indice_derrotado == indice_boss_da_fase(_fase);
        case 2: return _indice_derrotado == 1;
        case 3: return _indice_derrotado == 2;
    }

    return false;
}

function progresso_recompensa_apos_encontro(_fase, _indice_derrotado) {
    if (_indice_derrotado < indice_boss_da_fase(_fase)) {
        return _indice_derrotado + 0.5;
    }

    return _indice_derrotado;
}

function boss_resetar_estado() {
    global.boss_ativo = false;
    global.boss_tipo = "";
    global.boss_nome = "";
    global.boss_estagio = 0;
    global.boss_vida_maxima = 0;
    global.boss_alvo = 0;
    global.boss_alvo_min = 0;
    global.boss_alvo_max = 0;
    global.boss_alvo_oculto = false;
    global.boss_regra_texto = "";
    global.boss_funcao_a = 1;
    global.boss_funcao_b = 0;
    global.boss_funcao_texto = "";
    global.boss_ultima_saida = "";
    global.boss_ultimo_resultado = "";
    global.boss_turno = 1;
    global.boss_mensagem = "";
}

function boss_exato_ativo() {
    return variable_global_exists("boss_ativo")
        && global.boss_ativo
        && global.boss_tipo == "exato";
}

function boss_exato_nome_estagio() {
    if (!boss_exato_ativo()) return "";

    switch (global.boss_estagio) {
        case 1: return "Fechadura Aberta";
        case 2: return "Alvo Instavel";
        case 3: return "Funcao Instavel";
    }

    return "";
}

function boss_exato_alvo_da_mao(_min, _max) {
    var _hand = instance_find(obj_hand, 0);

    if (_hand != noone && variable_instance_exists(_hand, "mao")) {
        var _qtd_mao = array_length(_hand.mao);

        repeat (24) {
            var _indices = [];
            for (var i = 0; i < _qtd_mao; i++) {
                array_push(_indices, i);
            }

            var _qtd_usada = min(_qtd_mao, irandom_range(2, 4));
            var _valor = 0;

            for (var j = 0; j < _qtd_usada; j++) {
                var _idx_pool = irandom(array_length(_indices) - 1);
                var _idx_mao = _indices[_idx_pool];
                array_delete(_indices, _idx_pool, 1);

                var _numero = _hand.mao[_idx_mao];

                if (j == 0) {
                    _valor = _numero;
                } else if (choose(true, false)) {
                    _valor += _numero;
                } else {
                    _valor -= _numero;
                }
            }

            _valor = abs(_valor);
            if (_valor >= _min && _valor <= _max) {
                return _valor;
            }
        }
    }

    return irandom_range(_min, _max);
}

function boss_exato_sortear_alvo_estagio() {
    switch (global.boss_estagio) {
        case 1: return boss_exato_alvo_da_mao(8, 18);
        case 2: return boss_exato_alvo_da_mao(10, 18);
        case 3: return boss_exato_alvo_linear_da_mao();
    }

    return boss_exato_alvo_da_mao(8, 18);
}

function boss_exato_sortear_funcao_linear() {
    switch (irandom(4)) {
        case 0:
            global.boss_funcao_a = 2;
            global.boss_funcao_b = 0;
            global.boss_funcao_texto = "f(x) = 2x";
            break;

        case 1:
            global.boss_funcao_a = 2;
            global.boss_funcao_b = 1;
            global.boss_funcao_texto = "f(x) = 2x + 1";
            break;

        case 2:
            global.boss_funcao_a = 3;
            global.boss_funcao_b = -2;
            global.boss_funcao_texto = "f(x) = 3x - 2";
            break;

        case 3:
            global.boss_funcao_a = 1;
            global.boss_funcao_b = 7;
            global.boss_funcao_texto = "f(x) = x + 7";
            break;

        case 4:
            global.boss_funcao_a = 3;
            global.boss_funcao_b = 2;
            global.boss_funcao_texto = "f(x) = 3x + 2";
            break;
    }
}

function boss_exato_saida(_resultado) {
    if (boss_exato_ativo() && global.boss_estagio == 3) {
        return global.boss_funcao_a * _resultado + global.boss_funcao_b;
    }

    return _resultado;
}

function boss_exato_alvo_linear_da_mao() {
    repeat (24) {
        var _x_possivel = boss_exato_alvo_da_mao(1, 18);
        var _saida = floor(global.boss_funcao_a * _x_possivel + global.boss_funcao_b);

        if (_saida >= 1 && _saida <= 18) {
            return _saida;
        }
    }

    var _validos = [];

    for (var x = 1; x <= 18; x++) {
        var _alvo = floor(global.boss_funcao_a * x + global.boss_funcao_b);

        if (_alvo >= 1 && _alvo <= 18) {
            array_push(_validos, _alvo);
        }
    }

    if (array_length(_validos) > 0) {
        return _validos[irandom(array_length(_validos) - 1)];
    }

    return 18;
}

function boss_exato_preparar_estagio(_estagio) {
    global.boss_estagio = _estagio;
    global.boss_turno = 1;
    global.boss_ultimo_resultado = "";
    global.boss_ultima_saida = "";

    switch (global.boss_estagio) {
        case 1:
            global.boss_alvo = boss_exato_sortear_alvo_estagio();
            global.boss_alvo_oculto = false;
            global.boss_funcao_texto = "";
            global.boss_regra_texto = "Acerte exatamente o alvo.";
            global.boss_mensagem = "Erro nao causa dano.";
            break;

        case 2:
            global.boss_alvo = boss_exato_sortear_alvo_estagio();
            global.boss_alvo_oculto = false;
            global.boss_funcao_texto = "";
            global.boss_regra_texto = "Se errar, o alvo troca.";
            global.boss_mensagem = "A fechadura nao espera.";
            break;

        case 3:
            boss_exato_sortear_funcao_linear();
            global.boss_alvo = boss_exato_sortear_alvo_estagio();
            global.boss_alvo_oculto = false;
            global.boss_alvo_min = 0;
            global.boss_alvo_max = 0;
            global.boss_regra_texto = "Faca x para f(x) acertar o alvo.";
            global.boss_mensagem = "Se errar, alvo e funcao trocam.";
            break;
    }
}

function boss_exato_configurar() {
    global.boss_ativo = true;
    global.boss_tipo = "exato";
    global.boss_nome = "O Cofre Exato";
    global.boss_vida_maxima = 30;
    global.enemy_life = global.boss_vida_maxima;

    global.tentativas = max(global.tentativas, 6);
    global.ui_tentativas = global.tentativas;

    boss_exato_preparar_estagio(1);
}

function configurar_boss_atual() {
    boss_resetar_estado();

    if (encontro_atual_e_boss() && global.fase == 1) {
        boss_exato_configurar();
    }
}

function boss_exato_resultado_valido(_resultado) {
    var _saida = boss_exato_saida(_resultado);
    return floor(_saida) == _saida && _saida == global.boss_alvo;
}

function boss_exato_registrar_erro(_resultado) {
    var _saida = boss_exato_saida(_resultado);
    global.boss_ultima_saida = _saida;

    if (_saida < global.boss_alvo) {
        global.boss_mensagem = "Baixo demais: " + string(_saida);
        if (global.boss_estagio == 3) {
            boss_exato_sortear_funcao_linear();
            global.boss_alvo = boss_exato_sortear_alvo_estagio();
        }
    } else {
        global.boss_mensagem = "Alto demais: " + string(_saida);
        if (global.boss_estagio == 3) {
            boss_exato_sortear_funcao_linear();
            global.boss_alvo = boss_exato_sortear_alvo_estagio();
        }
    }

    if (global.boss_estagio == 2) {
        var _alvo_antigo = global.boss_alvo;
        repeat (6) {
            global.boss_alvo = boss_exato_sortear_alvo_estagio();
            if (global.boss_alvo != _alvo_antigo) break;
        }

        global.boss_mensagem += " | Novo alvo.";
    } else if (global.boss_estagio == 3) {
        global.boss_mensagem += " | Nova funcao e alvo.";
    }
}

function boss_exato_tentar_resultado(_resultado) {
    global.boss_ultimo_resultado = _resultado;

    if (boss_exato_resultado_valido(_resultado)) {
        var _estagio_quebrado = global.boss_estagio;
        global.enemy_life = max(0, global.boss_vida_maxima - _estagio_quebrado * 10);

        if (global.enemy_life > 0) {
            global.boss_estagio = _estagio_quebrado + 1;
            global.boss_mensagem = "Exato. Fechadura " + string(_estagio_quebrado) + " quebrou.";
        } else {
            global.boss_mensagem = "Exato. Cofre aberto.";
        }

        return true;
    }

    boss_exato_registrar_erro(_resultado);
    global.boss_turno += 1;
    return false;
}

function sortear_vida_inimigo() {
    var _indice = 0;

    if (variable_global_exists("inimigo_atual_fase")) _indice = global.inimigo_atual_fase;

    var _boss = encontro_atual_e_boss();

    switch (global.fase) {
        case 1:
            if (_boss) return 30;
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
	var _base_y = 80 + global.ui_top_space;
    var _gap = 55;

    for (var i = 0; i < _qtd_inimigos; i++) {
        var _peso = power(10, i);
        var _numero = floor(global.enemy_life / _peso) mod 10;

        var _enemy = instance_create_layer(_base_x - i * _gap, _base_y , "Instances", obj_enemy);
        _enemy.definir_numero_enemy(_numero, i);
        _enemy.visible = (i == 0 || global.enemy_life >= _peso);
		_enemy.image_xscale = 1.5;
		}
}

function iniciar_caminhada_arena(_abrir_recompensa, _criar_inimigo_no_fim) {
    if (!variable_global_exists("arena_scroll")) global.arena_scroll = 0;
    if (!variable_global_exists("caminhada_arena_duracao_base")) global.caminhada_arena_duracao_base = 90;
    if (!variable_global_exists("caminhada_arena_scroll_passo")) global.caminhada_arena_scroll_passo = 180;
    if (!variable_global_exists("progresso_visual_inicio")) global.progresso_visual_inicio = global.inimigo_atual_fase;
    if (!variable_global_exists("progresso_visual_alvo")) global.progresso_visual_alvo = global.inimigo_atual_fase;

    global.em_caminhada_arena = true;
    global.jogo_pausado = true;
    global.caminhada_arena_timer = 0;
    global.caminhada_arena_duracao = global.caminhada_arena_duracao_base;
    global.caminhada_arena_scroll_inicio = global.arena_scroll;
    global.caminhada_arena_scroll_alvo = global.arena_scroll + global.caminhada_arena_scroll_passo;
    global.caminhada_abrir_recompensa = _abrir_recompensa;
    global.caminhada_criar_inimigo_no_fim = _criar_inimigo_no_fim;
    global.progresso_visual = global.progresso_visual_inicio;

    with (obj_player) {
        x = room_width / 3;
        y = 110 + global.ui_top_space;
        sprite_index = spr_player_walking;
    }
}

function finalizar_caminhada_arena() {
    global.em_caminhada_arena = false;
    global.jogo_pausado = false;
    global.arena_scroll = global.caminhada_arena_scroll_alvo;
    global.progresso_visual = global.progresso_visual_alvo;

    with (obj_player) {
        x = room_width / 3;
        y = 110 + global.ui_top_space;
        sprite_index = spr_player_idle;
        image_index = 0;
    }

    if (global.caminhada_criar_inimigo_no_fim) {
        criar_inimigos();
    }

    if (global.caminhada_abrir_recompensa) {
        abrir_recompensa_roguelike();
    }

    global.caminhada_abrir_recompensa = false;
    global.caminhada_criar_inimigo_no_fim = true;
}

function proximo_inimigo() {
    with (obj_enemy) {
        instance_destroy();
    }

    inicializar_roguelike();

    if (!variable_global_exists("inimigos_por_fase")) global.inimigos_por_fase = encontros_combate_da_fase(global.fase);
    if (!variable_global_exists("inimigo_atual_fase")) global.inimigo_atual_fase = 0;
    if (!variable_global_exists("fase_maxima")) global.fase_maxima = 3;

    var _fase_derrotada = global.fase;
    var _indice_derrotado = global.inimigo_atual_fase;
    var _abrir_recompensa = recompensa_apos_encontro(_fase_derrotada, _indice_derrotado);

    global.inimigo_atual_fase++;

    if (global.inimigo_atual_fase >= encontros_combate_da_fase(global.fase)) {
        global.inimigo_atual_fase = 0;
        limpar_bonus_temporarios_fase();

        if (global.fase < global.fase_maxima) {
            global.fase++;
            global.precisa_atualizar_botoes = true;
            global.inimigos_por_fase = encontros_combate_da_fase(global.fase);

            global.cartas_selecionadas = [];
            global.indices_cartas_selecionadas = [];
            global.ops_selecionadas = [];
            global.expressao_partes = [];

            if (_abrir_recompensa) {
                global.tem_sala_pendente_apos_recompensa = true;
                global.sala_pendente_apos_recompensa = sala_da_fase(global.fase);
                abrir_recompensa_roguelike();
            } else {
                room_goto(sala_da_fase(global.fase));
            }

            exit;
        }
    }

    global.inimigos_por_fase = encontros_combate_da_fase(global.fase);

    resetar_roguelike_por_rodada();

    global.tentativas = tentativas_base_fase() + global.bonus_tentativas_proxima;
    global.bonus_tentativas_proxima = 0;
    global.ui_tentativas = global.tentativas;
    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];
    global.progresso_visual_inicio = _indice_derrotado;
    global.progresso_visual_alvo = global.inimigo_atual_fase;
    global.caminhada_continuar_apos_recompensa = false;

    if (_abrir_recompensa) {
        global.progresso_visual_alvo = progresso_recompensa_apos_encontro(_fase_derrotada, _indice_derrotado);
        global.caminhada_continuar_apos_recompensa = true;
        iniciar_caminhada_arena(true, false);
    } else {
        iniciar_caminhada_arena(false, true);
    }
}
