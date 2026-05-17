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
    global.boss_desafio_texto = "";
    global.boss_ultima_saida = "";
    global.boss_ultimo_resultado = "";
    global.boss_vida_por_estagio = 0;
    global.boss_turno = 1;
    global.boss_mensagem = "";
}

function boss_exato_ativo() {
    return variable_global_exists("boss_ativo")
        && global.boss_ativo
        && global.boss_tipo == "exato";
}

function boss_desafio_ativo() {
    return variable_global_exists("boss_ativo")
        && global.boss_ativo
        && global.boss_tipo == "desafio";
}

function boss_modificador_ativo() {
    return variable_global_exists("boss_ativo")
        && global.boss_ativo
        && global.boss_tipo == "modificador";
}

function boss_fala_atual() {
    if (!variable_global_exists("boss_ativo") || !global.boss_ativo) return "";

    var _fala = global.boss_mensagem;
    var _nome = "Boss";

    if (_fala == "") {
        _fala = "...";
    }

    if (variable_global_exists("boss_nome") && global.boss_nome != "") {
        _nome = global.boss_nome;
    }

    switch (global.boss_tipo) {
        case "exato":
            var _alvo = global.boss_alvo_oculto ? "??" : string(global.boss_alvo);

            if (global.boss_estagio == 3) {
                return _nome + "#" + _fala + " " + global.boss_funcao_texto + " -> " + _alvo + ".";
            }

            return _nome + "#" + _fala + " Alvo: " + _alvo + ".";

        case "modificador":
            switch (global.boss_estagio) {
                case 1: return _nome + "#" + _fala + " Dano = resultado -50.";
                case 2: return _nome + "#" + _fala + " Dano = resultado /2.";
                case 3: return _nome + "#" + _fala + " Dano = raiz x2.";
            }
            break;

        case "desafio":
            return _nome + "#" + _fala;
    }

    return _nome + "#" + _fala;
}

function boss_objetivo_hud_texto() {
    if (!variable_global_exists("boss_ativo") || !global.boss_ativo) return "";

    switch (global.boss_tipo) {
        case "exato":
            var _alvo = global.boss_alvo_oculto ? "??" : string(global.boss_alvo);

            if (global.boss_estagio == 3 && global.boss_funcao_texto != "") {
                return "Alvo: " + global.boss_funcao_texto + " -> " + _alvo;
            }

            return "Alvo: " + _alvo;

        case "modificador":
            return "Vida: " + string(max(0, ceil(global.enemy_life))) + "/" + string(global.boss_vida_maxima);

        case "desafio":
            if (global.boss_desafio_texto != "") {
                return "Regra: " + global.boss_desafio_texto;
            }

            return "Regra: " + global.boss_regra_texto;
    }

    return "";
}

function configurar_boss_atual() {
    boss_resetar_estado();

    if (encontro_atual_e_boss() && global.fase == 1) {
        boss_exato_configurar();
    } else if (encontro_atual_e_boss() && global.fase == 2) {
        boss_modificador_configurar();
    } else if (encontro_atual_e_boss() && global.fase == 3) {
        boss_desafio_configurar();
    }
}
