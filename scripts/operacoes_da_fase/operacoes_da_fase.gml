function operacoes_da_fase() {
    var _ops = [];

    switch (global.fase) {
        case 1: _ops = ["+", "-", "="]; break;
        case 2: _ops = ["+", "-", "*", "/", "="]; break;
        case 3: _ops = ["(", ")", "+", "-", "*", "/", "="]; break;
    }

    return _ops;
}
