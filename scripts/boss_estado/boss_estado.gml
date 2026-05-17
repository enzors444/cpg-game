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

function configurar_boss_atual() {
    boss_resetar_estado();

    if (encontro_atual_e_boss() && global.fase == 1) {
        boss_exato_configurar();
    } else if (encontro_atual_e_boss() && global.fase == 3) {
        boss_desafio_configurar();
    }
}
