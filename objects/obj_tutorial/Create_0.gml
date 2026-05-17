dialogos = [
    "Antes da luta, preste atencao: voce vence criando resultados com as cartas.",
    "Escolha numeros, coloque operacoes entre eles e aperte = para atacar.",
    "Acertos exatos sao melhores: eles podem render mais tentativas e rerolls.",
    "Algumas cartas especiais mudam as regras. Use o inventario quando ganhar uma.",
    "Os bosses nao sao so vida alta. Leia o desafio no visor antes de atacar.",
    "Quando estiver pronto, entre na Fase 1."
];

dialogo_atual = 0;
scroll_cenario = 0;
anim_player = 0;
anim_professor = 0;
transicao = false;
transicao_timer = 0;

tocar_musica(_01);

ok_x1 = room_width - 148;
ok_y1 = room_height - 92;
ok_x2 = room_width - 84;
ok_y2 = room_height - 64;
