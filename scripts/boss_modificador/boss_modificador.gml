function boss_modificador_texto_display() {
    if (!boss_modificador_ativo()) return "";

    switch (global.boss_estagio) {
        case 1: return " - 50";
        case 2: return "";
        case 3: return "";
    }

    return "";
}

function boss_modificador_resultado(_resultado) {
    switch (global.boss_estagio) {
        case 1: return _resultado - 50;
        case 2: return _resultado / 2;
        case 3: return sqrt(max(0, _resultado)) * 2;
    }

    return _resultado;
}

function boss_modificador_dano(_resultado) {
    return max(0, floor(boss_modificador_resultado(_resultado)));
}

function boss_modificador_vida_estagio(_estagio) {
    switch (_estagio) {
        case 1: return 65;
        case 2: return 70;
        case 3: return 42;
    }

    return 65;
}

function boss_modificador_preparar_estagio(_estagio) {
    global.boss_estagio = _estagio;
    global.boss_turno = 1;
    global.boss_ultimo_resultado = "";
    global.boss_ultima_saida = "";
    global.boss_vida_por_estagio = boss_modificador_vida_estagio(global.boss_estagio);
    global.boss_vida_maxima = global.boss_vida_por_estagio;
    global.enemy_life = global.boss_vida_por_estagio;

    switch (global.boss_estagio) {
        case 1:
            global.boss_regra_texto = "Seu resultado perde 50 antes do dano.";
            global.boss_mensagem = "Primeiro eu corto 50.";
            break;

        case 2:
            global.boss_regra_texto = "Seu resultado e dividido por 2.";
            global.boss_mensagem = "Agora eu divido por 2.";
            break;

        case 3:
            global.boss_regra_texto = "Raiz do resultado x2 vira dano.";
            global.boss_mensagem = "Raiz x2. Agora da para quebrar.";
            break;
    }
}

function boss_modificador_configurar() {
    global.boss_ativo = true;
    global.boss_tipo = "modificador";
    global.boss_nome = "Mago Janos";
    global.boss_vida_por_estagio = boss_modificador_vida_estagio(1);
    global.boss_vida_maxima = global.boss_vida_por_estagio;

    global.tentativas = max(global.tentativas, 8);
    global.ui_tentativas = global.tentativas;

    boss_modificador_preparar_estagio(1);
}

function boss_modificador_tentar_resultado(_resultado) {
    global.boss_ultimo_resultado = _resultado;

    var _resultado_final = boss_modificador_resultado(_resultado);
    var _dano_base = boss_modificador_dano(_resultado);
    var _bonus = bonus_sem_volta_valor(_dano_base);
    var _dano = _dano_base + _bonus;
    var _dano_aplicado = min(_dano, global.enemy_life);

    global.boss_ultima_saida = _resultado_final;
    global.enemy_life = max(0, global.enemy_life - _dano_aplicado);

    if (_dano_aplicado <= 0) {
        global.boss_turno += 1;
        global.boss_mensagem = "Virou " + string(floor(_resultado_final)) + ". Sem dano.";
        return false;
    }

    if (global.enemy_life <= 0) {
        var _estagio_vencido = global.boss_estagio;

        if (_estagio_vencido >= 3) {
            global.boss_mensagem = "Meu ritual acabou.";
        } else {
            boss_modificador_preparar_estagio(_estagio_vencido + 1);
            global.boss_mensagem = "Quebrou. Proximo ritual.";
        }

        return true;
    }

    global.boss_turno += 1;
    global.boss_mensagem = string(_dano_base) + " de dano passou.";
    return false;
}
