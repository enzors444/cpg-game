// Script: calcular_resultado(cartas, operacoes)
// ex: cartas = [3, 5, 2], operacoes = ["+", "-"]
// monta: 3 + 5 - 2 = 6

function calcular_resultado(_cartas, _ops) {
    var _resultado = _cartas[0];
    for (var i = 0; i < array_length(_ops); i++) {
        var _num = _cartas[i + 1];
        switch (_ops[i]) {
            case "+":  _resultado += _num; break;
            case "-":  _resultado -= _num; break;
            case "÷":  _resultado = (_num != 0) ? _resultado / _num : _resultado; break;
            case "^":  _resultado = power(_resultado, _num); break;
            case "√":  _resultado = sqrt(_num); break;
            case "log": _resultado = logn(_num, _resultado); break;
        }
    }
    return _resultado;
}