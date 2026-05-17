function fases() {
    var _ops = [];

    switch (global.fase) {
        case 1: _ops = ["+", "-"]; break;
        case 2: _ops = ["+", "-", "/", "*"]; break;
        case 3: _ops = ["(", ")", "+", "-", "/", "*"]; break;
    }

    if (variable_global_exists("quadrado_desbloqueado")
    && global.quadrado_desbloqueado
    && variable_global_exists("exponencial_usado_batalha")
    && !global.exponencial_usado_batalha
    && variable_global_exists("cartas_roguelike_escolhidas")
    && array_get_index(global.cartas_roguelike_escolhidas, "exponencial") != -1) {
        array_push(_ops, "^2");
    }

    return _ops;
}
