dialogos = [
    "Mosca:#Atencao, Piter! As provas finais do Inatel invadiram seus sonhos. Para acordar vitorioso e provar seu valor, voce precisa derrotar esses numeros antes que suas tentativas acabem.",
    "Mosca:#Use suas cartas para montar expressoes logicas: [Numero] + [Operador] + [Numero]. Se o seu resultado superar o valor do inimigo, voce avanca para o proximo combate ate chegar no Chefe Final da materia!",
    "Mosca:#Mas a verdadeira genialidade esta na precisao! Se a sua conta der o valor EXATO do inimigo, voce ganha tentativas extras para a proxima batalha e um Reroll bonus na manga.",
    "Mosca:#De tempos em tempos, voce conquistara Evolucoes Matematicas poderosas. Elas ficarao guardadas na sua carteira, ali no canto inferior esquerdo da sua visao. Use-as com sabedoria. Agora va, destrua essas provas!"
];

dialogo_atual = 0;
scroll_cenario = 0;
anim_player = 0;
anim_professor = 0;
transicao = false;
transicao_timer = 0;
texto_revelado = 0;
texto_timer = 0;
texto_velocidade = 0.9;
dialogo_som_tocando = false;

parar_musica();
tocar_sfx_loop_unico("dialogo", dialogo, 1.4);
dialogo_som_tocando = true;

ok_x1 = room_width - 148;
ok_y1 = room_height - 92;
ok_x2 = room_width - 84;
ok_y2 = room_height - 64;
