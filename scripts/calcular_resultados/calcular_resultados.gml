function calcular_resultado(_cartas, _ops) {
    var _resultado = _cartas[0];

    for (var i = 0; i < array_length(_ops); i++) {
        var _num = _cartas[i + 1];

        switch (_ops[i]) {
            case "+":    _resultado += _num; break;
            case "-":    _resultado -= _num; break;
            case "*":    _resultado *= _num; break;
            case "/":    _resultado = (_num != 0) ? _resultado / _num : _resultado; break;
            case "^":    _resultado = power(_resultado, _num); break;
            case "sqrt": _resultado = sqrt(_num); break;
            case "log":  _resultado = logn(_num, _resultado); break;
        }
    }

    return _resultado;
}

function max_cartas_por_numero() {
    return (global.fase <= 1) ? 1 : 2;
}

function pode_adicionar_carta_expressao() {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    var _cartas_seguidas = 0;

    for (var i = array_length(global.expressao_partes) - 1; i >= 0; i--) {
        var _parte = global.expressao_partes[i];
        if (_parte.tipo != "carta") break;

        _cartas_seguidas++;
    }

    return _cartas_seguidas < max_cartas_por_numero();
}

function pode_adicionar_operacao_expressao() {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    var _qtd_partes = array_length(global.expressao_partes);
    if (_qtd_partes <= 0) return false;

    return global.expressao_partes[_qtd_partes - 1].tipo == "carta";
}

function expressao_valida() {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    var _qtd_partes = array_length(global.expressao_partes);
    if (_qtd_partes < 3) return false;

    var _max_cartas = max_cartas_por_numero();
    var _cartas_seguidas = 0;
    var _tem_operacao = false;
    var _ultima_foi_operacao = false;

    for (var i = 0; i < _qtd_partes; i++) {
        var _parte = global.expressao_partes[i];

        if (_parte.tipo == "carta") {
            _cartas_seguidas++;
            if (_cartas_seguidas > _max_cartas) return false;

            _ultima_foi_operacao = false;
        } else {
            if (i == 0 || _ultima_foi_operacao || _cartas_seguidas <= 0) return false;

            _tem_operacao = true;
            _cartas_seguidas = 0;
            _ultima_foi_operacao = true;
        }
    }

    return _tem_operacao && !_ultima_foi_operacao && _cartas_seguidas > 0;
}

function calcular_resultado_expressao() {
    var _numeros = [];
    var _ops = [];
    var _numero_atual = 0;

    for (var i = 0; i < array_length(global.expressao_partes); i++) {
        var _parte = global.expressao_partes[i];

        if (_parte.tipo == "carta") {
            _numero_atual = _numero_atual * 10 + _parte.valor;
        } else {
            array_push(_numeros, _numero_atual);
            array_push(_ops, _parte.valor);
            _numero_atual = 0;
        }
    }

    array_push(_numeros, _numero_atual);

    return calcular_resultado(_numeros, _ops);
}

function remover_expressao_a_partir(_inicio) {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    for (var i = array_length(global.expressao_partes) - 1; i >= _inicio; i--) {
        var _parte = global.expressao_partes[i];

        if (_parte.tipo == "carta") {
            var _idx_carta = array_get_index(global.indices_cartas_selecionadas, _parte.indice);
            if (_idx_carta != -1) {
                array_delete(global.cartas_selecionadas, _idx_carta, 1);
                array_delete(global.indices_cartas_selecionadas, _idx_carta, 1);
            }

            var _indice_carta = _parte.indice;
            with (obj_carta) {
                if (!carta_selecao && indice_mao == _indice_carta) {
                    selecionada = false;
                    image_blend = c_white;
                }
            }
        } else {
            var _idx_op = array_get_index(global.ops_selecionadas, _parte.valor);
            if (_idx_op != -1) {
                array_delete(global.ops_selecionadas, _idx_op, 1);
            }

            var _operacao = _parte.valor;
            with (obj_btn_operacao) {
                if (operacao == _operacao) {
                    selecionada = false;
                    image_blend = c_white;
                }
            }
        }

        array_delete(global.expressao_partes, i, 1);
    }
}

function limpar_expressao() {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    remover_expressao_a_partir(0);

    global.cartas_selecionadas = [];
    global.indices_cartas_selecionadas = [];
    global.ops_selecionadas = [];
    global.expressao_partes = [];
}

function montar_texto_expressao(_mostrar_resultado) {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    if (array_length(global.expressao_partes) <= 0) {
        return "...";
    }

    var _texto = "";
    var _ultima_foi_carta = false;

    for (var i = 0; i < array_length(global.expressao_partes); i++) {
        var _parte = global.expressao_partes[i];

        if (_parte.tipo == "carta") {
            if (_texto != "" && !_ultima_foi_carta) _texto += " ";
            _texto += string(_parte.valor);
            _ultima_foi_carta = true;
        } else {
            if (_texto != "") _texto += " ";
            _texto += string(_parte.valor);
            _ultima_foi_carta = false;
        }
    }

    if (_mostrar_resultado && expressao_valida()) {
        _texto += " = " + string(calcular_resultado_expressao());
    }

    return _texto;
}
