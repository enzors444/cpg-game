function valor_inteiro(_valor) {
    return floor(_valor) == _valor;
}

function valor_tres_digitos(_valor) {
    return _valor >= 100 && _valor <= 999;
}

function boss_desafio_linha() {
    switch (global.boss_estagio) {
        case 1: return "Numero par maior que 30.";
        case 2: return "Impar entre 100 e 200.";
        case 3: return "Resultado entre 90 e 120.";
    }

    return "";
}

function boss_desafio_preparar_estagio(_estagio) {
    global.boss_estagio = _estagio;
    global.boss_turno = 1;
    global.boss_ultimo_resultado = "";
    global.boss_ultima_saida = "";
    global.boss_desafio_texto = boss_desafio_linha();
    global.boss_regra_texto = "Resultado inteiro. Erro nao causa dano.";

    switch (global.boss_estagio) {
        case 1:
            global.boss_mensagem = "Prova 1: par maior que 30.";
            break;

        case 2:
            global.boss_mensagem = "Prova 2: impar de 100 a 200.";
            break;

        case 3:
            global.boss_mensagem = "Prova 3: fique entre 90 e 120.";
            break;
    }
}

function boss_desafio_configurar() {
    global.boss_ativo = true;
    global.boss_tipo = "desafio";
    global.boss_nome = "Mega Renzo";
    global.boss_vida_maxima = 3;
    global.enemy_life = global.boss_vida_maxima;

    global.tentativas = max(global.tentativas, 8);
    global.ui_tentativas = global.tentativas;

    boss_desafio_preparar_estagio(1);
}

function boss_desafio_resultado_valido(_resultado) {
    if (!valor_inteiro(_resultado)) return false;

    _resultado = floor(_resultado);

    switch (global.boss_estagio) {
        case 1:
            return _resultado > 30 && (_resultado mod 2) == 0;

        case 2:
            return _resultado >= 100 && _resultado <= 200 && (_resultado mod 2) != 0;

        case 3:
            return _resultado >= 90 && _resultado <= 120;
    }

    return false;
}

function boss_desafio_feedback(_resultado) {
    if (!valor_inteiro(_resultado)) return "Sem decimal. Quero inteiro.";

    _resultado = floor(_resultado);

    switch (global.boss_estagio) {
        case 1:
            if (_resultado <= 30) return "Muito baixo. Passe de 30.";
            if ((_resultado mod 2) != 0) return "Isso e impar. Quero par.";
            return "Quase. Ajuste a prova.";

        case 2:
            if (_resultado < 100) return "Baixo. Chegue em 100.";
            if (_resultado > 200) return "Alto. Passe de 200 nao.";
            if ((_resultado mod 2) == 0) return "Par demais. Quero impar.";
            break;

        case 3:
            if (_resultado < 90) return "Baixo. Suba ate 90.";
            if (_resultado > 120) return "Alto. Fique ate 120.";
            break;
    }

    return "Ainda nao passou.";
}

function boss_desafio_tentar_resultado(_resultado) {
    global.boss_ultimo_resultado = _resultado;

    if (boss_desafio_resultado_valido(_resultado)) {
        var _estagio_vencido = global.boss_estagio;
        global.enemy_life = max(0, global.boss_vida_maxima - _estagio_vencido);

        if (global.enemy_life > 0) {
            boss_desafio_preparar_estagio(_estagio_vencido + 1);
            global.boss_mensagem = "Passou. Vem a proxima.";
        } else {
            global.boss_mensagem = "Voce venceu minhas provas.";
        }

        return true;
    }

    global.boss_mensagem = boss_desafio_feedback(_resultado);
    global.boss_turno += 1;
    return false;
}
