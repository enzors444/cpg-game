// Create do obj_game
var _fase_da_sala = fase_da_sala_atual();
var _admin_teleporte = variable_global_exists("admin_teleporte_ativo") && global.admin_teleporte_ativo;
var _admin_fase = _fase_da_sala;
var _admin_boss = false;

if (_admin_teleporte) {
    _admin_fase = clamp(global.admin_teleporte_fase, 1, 3);
    _admin_boss = variable_global_exists("admin_teleporte_boss") && global.admin_teleporte_boss;
}

var _nova_run = (_fase_da_sala == 1) && !_admin_teleporte;

global.fase = _admin_fase;

if (_nova_run) {
    resetar_roguelike();
}

inicializar_roguelike();
resetar_roguelike_por_rodada();

if (!variable_global_exists("bonus_tentativas_proxima") || _nova_run) {
    global.bonus_tentativas_proxima = 0;
}

global.tentativas = tentativas_base_fase() + global.bonus_tentativas_proxima;
global.bonus_tentativas_proxima = 0;
global.ui_tentativas = global.tentativas;
global.ui_top_space = 50;
global.inimigos_por_fase = encontros_combate_da_fase(global.fase);
global.inimigo_atual_fase = _admin_boss ? indice_boss_da_fase(global.fase) : 0;
global.fase_maxima = 3;
global.precisa_atualizar_botoes = false;
global.cargas_reroll_mao = 3;
global.fase_reroll_mao = global.fase;
global.carta_escolhida = -1;
global.jogo_pausado = false;
global.jogo_vencido = false;
global.morte_numeros_ativa = false;
global.pause_ativo = false;
global.admin_menu_ativo = false;
global.em_caminhada_arena = false;
global.caminhada_arena_timer = 0;
global.caminhada_arena_duracao_base = 90;
global.caminhada_arena_duracao = global.caminhada_arena_duracao_base;
global.caminhada_arena_scroll_passo = 180;
global.caminhada_arena_scroll_inicio = 0;
global.caminhada_arena_scroll_alvo = 0;
global.caminhada_abrir_recompensa = false;
global.caminhada_criar_inimigo_no_fim = true;
global.caminhada_continuar_apos_recompensa = false;
global.progresso_inicio_barra = -0.45;
global.progresso_visual = global.progresso_inicio_barra;
global.progresso_visual_inicio = global.progresso_inicio_barra;
global.progresso_visual_alvo = global.inimigo_atual_fase;
global.mao = [];
global.cartas_selecionadas = [];
global.indices_cartas_selecionadas = [];
global.ops_selecionadas = [];
global.expressao_partes = [];
global.boss_display_stream_texto = "";
global.boss_display_stream_pos = 0;
global.boss_display_stream_vel = 0.22;

tocar_musica_fase(global.fase, false);

boss_resetar_estado();
global.cargas_reroll_mao = cargas_reroll_maximas();
game_over_salvar_checkpoint_fase();

if (!variable_global_exists("arena_scroll") || _nova_run) {
    global.arena_scroll = 0;
}

instance_create_layer(0, 0, "Instances", obj_arena_background);
instance_create_layer(player_x_da_fase(global.fase), 110 + global.ui_top_space, "Instances", obj_player);
instance_create_layer(0, 0, "Instances", obj_hand);
instance_create_layer(0, 0, "Instances", obj_ui);

criar_botoes_operacao = function() {
    with (obj_btn_operacao) {
        instance_destroy();
    }

    global.ops = operacoes_da_fase();
    var _linha_y = room_height - 30;
    var _gap = 54;
    var _reserva_lateral = 80;
    var _qtd_ops = array_length(global.ops);

    if (_qtd_ops > 1) {
        _gap = min(_gap, (room_width - _reserva_lateral * 2) / (_qtd_ops - 1));
    }

    var _largura_ops = max(0, _qtd_ops - 1) * _gap;
    var _start_ops = room_width / 2 - _largura_ops / 2;

    for (var i = 0; i < _qtd_ops; i++) {
        var _btn_op = instance_create_layer(_start_ops + i * _gap, _linha_y, "Instances", obj_btn_operacao);
        _btn_op.operacao = global.ops[i];
    }

    var _margem_lateral = 8;
    var _controle_w = 48;
    var _util_x = room_width - _margem_lateral - _controle_w / 2;

    var _btn_reroll = instance_create_layer(_util_x, _linha_y - 58, "Instances", obj_btn_operacao);
    _btn_reroll.operacao = "R";

    var _btn_clear = instance_create_layer(_util_x, _linha_y, "Instances", obj_btn_operacao);
    _btn_clear.operacao = "E";
};

criar_botoes_operacao();

if (_admin_teleporte) {
    global.admin_teleporte_ativo = false;
    global.admin_teleporte_fase = 0;
    global.admin_teleporte_boss = false;
    global.arena_scroll = global.inimigo_atual_fase * global.caminhada_arena_scroll_passo;
    global.progresso_visual = global.inimigo_atual_fase;
    global.progresso_visual_inicio = global.inimigo_atual_fase;
    global.progresso_visual_alvo = global.inimigo_atual_fase;
    criar_inimigos();
} else {
    iniciar_caminhada_arena(false, true);
}
