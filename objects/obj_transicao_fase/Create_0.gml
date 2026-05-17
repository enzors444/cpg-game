depth = -100000;

if (!variable_global_exists("transicao_fase_ativa")) global.transicao_fase_ativa = false;
if (!variable_global_exists("transicao_fase_timer")) global.transicao_fase_timer = 0;
if (!variable_global_exists("transicao_fase_duracao")) global.transicao_fase_duracao = 95;
if (!variable_global_exists("transicao_fase_sala")) global.transicao_fase_sala = Room1;
if (!variable_global_exists("transicao_fase_titulo")) global.transicao_fase_titulo = "Fase 1";
if (!variable_global_exists("transicao_fase_subtitulo")) global.transicao_fase_subtitulo = "";
