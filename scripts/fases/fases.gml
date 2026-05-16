function fases() {
    switch (global.fase) {
        case 1: return ["+", "-"];
        case 2: return ["+", "-", "/", "*"];
        case 3: return ["(", ")", "+", "-", "/", "*", "log", "^", "sqrt"];
    }
}
