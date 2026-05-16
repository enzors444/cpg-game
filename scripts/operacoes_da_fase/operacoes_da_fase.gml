function operacoes_da_fase() {
    switch (global.fase) {
        case 1: return ["+", "-", "="];
        case 2: return ["+", "-", "*", "/", "="];
        case 3: return ["(", ")", "+", "-", "*", "/", "="];
    }
}
