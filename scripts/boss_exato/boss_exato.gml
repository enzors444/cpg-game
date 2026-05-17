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

    for (var i = 1; i <= 18; i++) {
        var _alvo = floor(global.boss_funcao_a * i + global.boss_funcao_b);

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
