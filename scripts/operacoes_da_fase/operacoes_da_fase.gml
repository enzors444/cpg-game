function operacoes_da_fase() {
    var _ops = [];

    switch (global.fase) {
        case 1: _ops = ["+", "-", "="]; break;
        case 2: _ops = ["+", "-", "*", "/", "="]; break;
        case 3: _ops = ["(", ")", "+", "-", "*", "/", "="]; break;
    }

    if (variable_global_exists("quadrado_desbloqueado") && global.quadrado_desbloqueado) {
        var _ops_com_quadrado = [];

        for (var i = 0; i < array_length(_ops); i++) {
            if (_ops[i] == "=") {
                array_push(_ops_com_quadrado, "^2");
            }

            array_push(_ops_com_quadrado, _ops[i]);
        }

        return _ops_com_quadrado;
    }

    return _ops;
}
