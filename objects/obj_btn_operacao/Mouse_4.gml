if (!clique_manual_operacao) {
    exit;
}

clique_manual_operacao = false;

var _meia_largura_clique = 24;
var _meia_altura_clique = 24;

if (!point_in_rectangle(mouse_x, mouse_y, x - _meia_largura_clique, y - _meia_altura_clique, x + _meia_largura_clique, y + _meia_altura_clique)) {
    exit;
}

if (global.jogo_pausado) {
    exit;
}

if (operacao == "R") {
    rerrolar_mao();
    exit;
}

if (operacao == "E") {
    limpar_expressao();
    exit;
}

if (operacao == "^2") {
    alternar_quadrado_expressao();
    exit;
}

if (operacao == "(" || operacao == ")") {
    if (!pode_adicionar_parentese_expressao(operacao)) exit;

    array_push(global.expressao_partes, { tipo: "paren", valor: operacao });
    exit;
}

if (operacao == "=") {
    if (!expressao_valida()) exit;

    var _enemy = instance_find(obj_enemy, 0);
    if (_enemy == noone) exit;

    var _resultado = calcular_resultado_expressao();
    registrar_numero_grudado_rodada(global.expressao_partes);
    registrar_exponencial_se_usado();

    var _vida_antes = global.enemy_life;
    var _dano = max(0, _resultado);

    if (boss_exato_ativo()) {
        var _acertou_boss_exato = boss_exato_tentar_resultado(_resultado);

        if (_acertou_boss_exato) {
            adicionar_reroll_acerto_exato();

            if (global.enemy_life <= 0) {
                var _bonus_exato_boss = 1;
                if (variable_global_exists("bonus_precisao")) {
                    _bonus_exato_boss += global.bonus_precisao;
                }

                global.bonus_tentativas_proxima += _bonus_exato_boss;
                criar_criticos_numeros_visiveis();

                recomprar_cartas();
                proximo_inimigo();
            } else {
                var _mensagem_boss_exato = global.boss_mensagem;
                recomprar_cartas();
                boss_exato_preparar_estagio(global.boss_estagio);
                global.boss_mensagem = _mensagem_boss_exato;
            }
        } else {
            if (global.tentativas > 1) {
                tocar_sfx(tentativa, 0.85);
            }

            global.tentativas--;
            if (global.tentativas <= 0) {
                game_over();
            } else {
                recomprar_cartas();
            }
        }
    } else if (boss_modificador_ativo()) {
        var _avancou_boss_modificador = boss_modificador_tentar_resultado(_resultado);

        if (_avancou_boss_modificador) {
            if (global.enemy_life <= 0) {
                criar_criticos_numeros_visiveis();
                recomprar_cartas();
                proximo_inimigo();
            } else {
                recomprar_cartas();
            }
        } else {
            if (global.tentativas > 1) {
                tocar_sfx(tentativa, 0.85);
            }

            global.tentativas--;
            if (global.tentativas <= 0) {
                game_over();
            } else {
                recomprar_cartas();
            }
        }
    } else if (boss_desafio_ativo()) {
        var _acertou_boss_desafio = boss_desafio_tentar_resultado(_resultado);

        if (_acertou_boss_desafio) {
            if (global.enemy_life <= 0) {
                criar_criticos_numeros_visiveis();
                recomprar_cartas();
                proximo_inimigo();
            } else {
                recomprar_cartas();
            }
        } else {
            if (global.tentativas > 1) {
                tocar_sfx(tentativa, 0.85);
            }

            global.tentativas--;
            if (global.tentativas <= 0) {
                game_over();
            } else {
                recomprar_cartas();
            }
        }
    } else {
        _dano += bonus_sem_volta_valor(_dano);

        var _vida_depois = max(0, _vida_antes - _dano);

        global.enemy_life = _vida_depois;

        var _acertou_exato = (global.enemy_life <= 0 && _dano == _vida_antes);

        if (global.enemy_life <= 0) {
            var _ganhou_reroll_exato = false;

            if (_acertou_exato) {
                var _bonus_exato = 1;
                if (variable_global_exists("bonus_precisao")) {
                    _bonus_exato += global.bonus_precisao;
                }

                global.bonus_tentativas_proxima += _bonus_exato;
                _ganhou_reroll_exato = true;
                criar_criticos_numeros_visiveis();
            }

            recomprar_cartas();
            proximo_inimigo();

            if (_ganhou_reroll_exato) {
                adicionar_reroll_acerto_exato();
            }
        } else {
            if (global.tentativas > 1) {
                tocar_sfx(tentativa, 0.85);
            }

            global.tentativas--;
            if (global.tentativas <= 0) {
                game_over();
            } else {
                recomprar_cartas();
            }
        }
    }

    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];

    with (obj_carta) {
        if (!carta_selecao) {
            selecionada = false;
            image_blend = c_white;
        }
    }

    with (obj_btn_operacao) {
        selecionada = false;
        image_blend = c_white;
    }
} else {
    if (!selecionada && array_length(global.ops_selecionadas) < 4) {
        if (!pode_adicionar_operacao_expressao()) exit;

        selecionada = true;
        array_push(global.ops_selecionadas, operacao);
        array_push(global.expressao_partes, { tipo: "op", valor: operacao });
    } else if (selecionada) {
        if (array_length(global.ops_selecionadas) < 4
        && pode_adicionar_operacao_expressao()
        && pode_repetir_operacao_rodada()) {
            array_push(global.ops_selecionadas, operacao);
            array_push(global.expressao_partes, { tipo: "op", valor: operacao, repetida: true });
            global.repeticoes_operacao_rodada += 1;
            exit;
        }

        for (var i = 0; i < array_length(global.expressao_partes); i++) {
            var _parte = global.expressao_partes[i];
            if (_parte.tipo == "op" && _parte.valor == operacao) {
                remover_expressao_a_partir(i);
                exit;
            }
        }

        selecionada = false;
    }
}
