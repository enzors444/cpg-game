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
    if (!variable_global_exists("musica_volume")) global.musica_volume = 0.75;

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
