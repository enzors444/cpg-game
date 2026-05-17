function boss_modificador_nome_estagio() {
    if (!boss_modificador_ativo()) return "";

    switch (global.boss_estagio) {
        case 1: return "Subtracao Vermelha";
        case 2: return "Divisao Forcada";
        case 3: return "Raiz Final";
    }

    return "";
}

function boss_modificador_texto_display() {
    if (!boss_modificador_ativo()) return "";

    switch (global.boss_estagio) {
        case 1: return " - 50";
        case 2: return " / 2";
        case 3: return " raiz";
    }

    return "";
}

function boss_modificador_resultado(_resultado) {
    switch (global.boss_estagio) {
        case 1: return _resultado - 50;
        case 2: return _resultado / 2;
        case 3: return sqrt(max(0, _resultado));
    }

    return _resultado;
}

function boss_modificador_dano(_resultado) {
    return max(0, floor(boss_modificador_resultado(_resultado)));
}

function boss_modificador_vida_minima_estagio(_estagio) {
    return max(0, global.boss_vida_maxima - _estagio * global.boss_vida_por_estagio);
}

function boss_modificador_preparar_estagio(_estagio) {
    global.boss_estagio = _estagio;
    global.boss_turno = 1;
    global.boss_ultimo_resultado = "";
    global.boss_ultima_saida = "";

    switch (global.boss_estagio) {
        case 1:
            global.boss_regra_texto = "Seu resultado perde 50 antes do dano.";
            global.boss_mensagem = "O visor vermelho corta seu ataque.";
            break;

        case 2:
            global.boss_regra_texto = "Seu resultado e dividido por 2.";
            global.boss_mensagem = "Metade do ataque chega nele.";
            break;

        case 3:
            global.boss_regra_texto = "Seu resultado vira raiz antes do dano.";
            global.boss_mensagem = "So sobra a raiz do ataque.";
            break;
    }
}

function boss_modificador_configurar() {
    global.boss_ativo = true;
    global.boss_tipo = "modificador";
    global.boss_nome = "O Operador Vermelho";
    global.boss_vida_maxima = 240;
    global.boss_vida_por_estagio = 80;
    global.enemy_life = global.boss_vida_maxima;

    global.tentativas = max(global.tentativas, 6);
    global.ui_tentativas = global.tentativas;

    boss_modificador_preparar_estagio(1);
}

function boss_modificador_tentar_resultado(_resultado) {
    global.boss_ultimo_resultado = _resultado;

    var _resultado_final = boss_modificador_resultado(_resultado);
    var _dano_base = boss_modificador_dano(_resultado);
    var _bonus = bonus_sem_volta_valor(_dano_base);
    var _dano = _dano_base + _bonus;
    var _vida_minima = boss_modificador_vida_minima_estagio(global.boss_estagio);
    var _dano_necessario = max(0, global.enemy_life - _vida_minima);
    var _dano_aplicado = min(_dano, _dano_necessario);

    global.boss_ultima_saida = _resultado_final;
    global.enemy_life = max(_vida_minima, global.enemy_life - _dano_aplicado);

    if (_dano_aplicado <= 0) {
        global.boss_turno += 1;
        global.boss_mensagem = "Resultado final: " + string(floor(_resultado_final)) + ". Sem dano.";
        return false;
    }

    if (global.enemy_life <= _vida_minima) {
        var _estagio_vencido = global.boss_estagio;

        if (global.enemy_life <= 0) {
            global.boss_mensagem = "O operador foi quebrado.";
        } else {
            boss_modificador_preparar_estagio(_estagio_vencido + 1);
            global.boss_mensagem = "Estagio " + string(_estagio_vencido) + " vencido.";
        }

        return true;
    }

    global.boss_turno += 1;
    global.boss_mensagem = "Resultado final: " + string(_dano_base) + ".";
    return false;
}
