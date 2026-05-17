depth = -100000;

tela_final_tipo = (room == Vitoria) ? "vitoria" : "gameover";
tela_final_hover = -1;
tela_final_anim = 0;

if (tela_final_tipo == "vitoria") {
    tela_final_titulo = "VITORIA";
    tela_final_subtitulo = "Todos os desafios foram concluidos.";
    tela_final_sprite = spr_vitoria;
    tela_final_botoes = [
        { texto: "MENU", acao: "menu" },
        { texto: "JOGAR", acao: "jogar" }
    ];
    parar_musica();
} else {
    tela_final_titulo = "PEGOU DP";
    tela_final_subtitulo = "";
    tela_final_sprite = spr_gameOver;
    tela_final_botoes = [
        { texto: "REINICIAR", acao: "tentar" },
        { texto: "MENU", acao: "menu" }
    ];
    tocar_musica(gameover_music);
}
