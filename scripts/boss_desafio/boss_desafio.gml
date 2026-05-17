function valor_inteiro(_valor) {
    return floor(_valor) == _valor;
}

function valor_tres_digitos(_valor) {
    return _valor >= 100 && _valor <= 999;
}

function valor_primo(_valor) {
    if (!valor_inteiro(_valor)) return false;

    _valor = floor(_valor);

    if (_valor < 2) return false;
    if (_valor == 2) return true;
    if ((_valor mod 2) == 0) return false;

    for (var i = 3; i * i <= _valor; i += 2) {
        if ((_valor mod i) == 0) return false;
    }

    return true;
}

function valor_quadrado_perfeito(_valor) {
    if (!valor_inteiro(_valor) || _valor < 0) return false;

    var _raiz = floor(sqrt(_valor));
    return _raiz * _raiz == _valor;
}

function boss_desafio_nome_estagio() {
    if (!boss_desafio_ativo()) return "";

    switch (global.boss_estagio) {
        case 1: return "Crivo Final";
        case 2: return "Soma Impar";
        case 3: return "Raiz Fechada";
    }

    return "";
}

function boss_desafio_linha() {
    switch (global.boss_estagio) {
        case 1: return "Primo de 3 digitos maior que 27.";
        case 2: return "Impar de 3 digitos multiplo de 9.";
        case 3: return "Quadrado perfeito de 3 digitos.";
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
    global.boss_mensagem = "Erro nao causa dano.";
}

function boss_desafio_configurar() {
    global.boss_ativo = true;
    global.boss_tipo = "desafio";
    global.boss_nome = "O Examinador Final";
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
            return valor_tres_digitos(_resultado) && _resultado > 27 && valor_primo(_resultado);

        case 2:
            return valor_tres_digitos(_resultado) && (_resultado mod 2) != 0 && (_resultado mod 9) == 0;

        case 3:
            return valor_tres_digitos(_resultado) && valor_quadrado_perfeito(_resultado);
    }

    return false;
}

function boss_desafio_feedback(_resultado) {
    if (!valor_inteiro(_resultado)) return "Precisa ser inteiro.";

    _resultado = floor(_resultado);

    if (!valor_tres_digitos(_resultado)) return "Precisa ter 3 digitos.";

    switch (global.boss_estagio) {
        case 1:
            if (_resultado <= 27) return "Precisa ser maior que 27.";
            if (!valor_primo(_resultado)) return "Nao e primo.";
            break;

        case 2:
            if ((_resultado mod 2) == 0) return "Precisa ser impar.";
            if ((_resultado mod 9) != 0) return "Nao e multiplo de 9.";
            break;

        case 3:
            if (!valor_quadrado_perfeito(_resultado)) return "Nao e quadrado perfeito.";
            break;
    }

    return "Nao cumpre o desafio.";
}

function boss_desafio_tentar_resultado(_resultado) {
    global.boss_ultimo_resultado = _resultado;

    if (boss_desafio_resultado_valido(_resultado)) {
        var _estagio_vencido = global.boss_estagio;
        global.enemy_life = max(0, global.boss_vida_maxima - _estagio_vencido);

        if (global.enemy_life > 0) {
            boss_desafio_preparar_estagio(_estagio_vencido + 1);
            global.boss_mensagem = "Desafio " + string(_estagio_vencido) + " concluido.";
        } else {
            global.boss_mensagem = "Todos os desafios foram concluidos.";
        }

        return true;
    }

    global.boss_mensagem = boss_desafio_feedback(_resultado);
    global.boss_turno += 1;
    return false;
}
