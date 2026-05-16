function fases() {
    var _ops = [];

    switch (global.fase) {
        case 1: _ops = ["+", "-"]; break;
        case 2: _ops = ["+", "-", "/", "*"]; break;
        case 3: _ops = ["(", ")", "+", "-", "/", "*"]; break;
    }

    if (variable_global_exists("quadrado_desbloqueado") && global.quadrado_desbloqueado) {
        array_push(_ops, "^2");
    }

    return _ops;
}
