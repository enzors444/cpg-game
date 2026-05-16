// 1. sorteia
var _pool = [0,1,2,3,4,5,6,7,8,9];
cartas = array_create(3);
for (var i = 0; i < 3; i++) {
    var _idx = irandom(array_length(_pool) - 1);
    cartas[i] = _pool[_idx];
    array_delete(_pool, _idx, 1);
}

// 2. cria instâncias
var _gap   = 140;
var _start = room_width/2 - _gap;
for (var i = 0; i < 3; i++) {
    var _inst         = instance_create_layer(_start + i * _gap, room_height/2, "UI", obj_carta);
    _inst.numero      = cartas[i];
    _inst.image_index = cartas[i]; // ← linha adicionada
}

// 3. função
function confirmar() {
    with (obj_carta) { instance_destroy(); }
    instance_destroy();
    global.jogo_pausado = false;
}