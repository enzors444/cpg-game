if (_resultado > obj_enemy.vida) {
    proximo_inimigo(); // ← direto, sem with
} else {
    global.tentativas--;
    if (global.tentativas <= 0) {
        game_over(); // ← direto, sem with
    }
}