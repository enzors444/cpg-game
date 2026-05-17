function som_da_fase(_fase, _boss) {
    if (_boss) {
        switch (_fase) {
            case 1: return Boss_1;
            case 2: return Boss_2;
            case 3: return Boss_3;
        }
    }

    switch (_fase) {
        case 1: return _01;
        case 2: return _02;
        case 3: return _03;
    }

    return _01;
}

function tocar_musica(_som) {
    if (!variable_global_exists("musica_atual")) global.musica_atual = noone;
    if (!variable_global_exists("musica_instancia")) global.musica_instancia = noone;
    if (!variable_global_exists("musica_volume")) global.musica_volume = 0.35;

    var _mesma_musica = global.musica_atual == _som;
    var _tocando = global.musica_instancia != noone && audio_is_playing(global.musica_instancia);

    if (_mesma_musica && _tocando) {
        return;
    }

    if (global.musica_instancia != noone) {
        audio_stop_sound(global.musica_instancia);
    }

    global.musica_atual = _som;
    global.musica_instancia = audio_play_sound(_som, 1, true);
    audio_sound_gain(global.musica_instancia, global.musica_volume, 0);
}

function tocar_musica_fase(_fase, _boss) {
    tocar_musica(som_da_fase(_fase, _boss));
}

function parar_musica() {
    if (!variable_global_exists("musica_atual")) global.musica_atual = noone;
    if (!variable_global_exists("musica_instancia")) global.musica_instancia = noone;

    if (global.musica_instancia != noone) {
        audio_stop_sound(global.musica_instancia);
    }

    global.musica_atual = noone;
    global.musica_instancia = noone;
}

function tocar_sfx(_som, _volume) {
    var _instancia = audio_play_sound(_som, 2, false);
    audio_sound_gain(_instancia, _volume, 0);
    return _instancia;
}

function tocar_sfx_unico(_canal, _som, _volume) {
    var _nome_global = "sfx_" + _canal + "_instancia";
    var _instancia_atual = noone;

    if (variable_global_exists(_nome_global)) {
        _instancia_atual = variable_global_get(_nome_global);
    }

    if (_instancia_atual != noone && audio_is_playing(_instancia_atual)) {
        audio_stop_sound(_instancia_atual);
    }

    var _nova_instancia = tocar_sfx(_som, _volume);
    variable_global_set(_nome_global, _nova_instancia);
    return _nova_instancia;
}

function tocar_sfx_loop_unico(_canal, _som, _volume) {
    var _nome_global = "sfx_" + _canal + "_instancia";
    var _instancia_atual = noone;

    if (variable_global_exists(_nome_global)) {
        _instancia_atual = variable_global_get(_nome_global);
    }

    if (_instancia_atual != noone && audio_is_playing(_instancia_atual)) {
        return _instancia_atual;
    }

    var _nova_instancia = audio_play_sound(_som, 2, true);
    audio_sound_gain(_nova_instancia, _volume, 0);
    variable_global_set(_nome_global, _nova_instancia);
    return _nova_instancia;
}

function parar_sfx_unico(_canal) {
    var _nome_global = "sfx_" + _canal + "_instancia";

    if (!variable_global_exists(_nome_global)) {
        return;
    }

    var _instancia = variable_global_get(_nome_global);

    if (_instancia != noone && audio_is_playing(_instancia)) {
        audio_stop_sound(_instancia);
    }

    variable_global_set(_nome_global, noone);
}
