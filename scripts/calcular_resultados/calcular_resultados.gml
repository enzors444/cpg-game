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
    var _max = (global.fase <= 1) ? 1 : 2;

    if (variable_global_exists("bonus_cartas_seguidas_temporario")
    && variable_global_exists("fase_bonus_numero_grudado")
    && global.fase_bonus_numero_grudado == global.fase) {
        _max += global.bonus_cartas_seguidas_temporario;
    }

    return _max;
}

function pode_adicionar_carta_expressao() {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    var _qtd_partes = array_length(global.expressao_partes);
    if (_qtd_partes > 0) {
        var _ultima = global.expressao_partes[_qtd_partes - 1];
        if (_ultima.tipo == "paren" && _ultima.valor == ")") return false;
    }

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

    var _ultima = global.expressao_partes[_qtd_partes - 1];
    return _ultima.tipo == "carta" || (_ultima.tipo == "paren" && _ultima.valor == ")");
}

function contar_parenteses_abertos() {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    var _abertos = 0;

    for (var i = 0; i < array_length(global.expressao_partes); i++) {
        var _parte = global.expressao_partes[i];

        if (_parte.tipo == "paren") {
            if (_parte.valor == "(") {
                _abertos++;
            } else {
                _abertos--;
            }
        }
    }

    return _abertos;
}

function pode_adicionar_parentese_expressao(_parentese) {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    var _qtd_partes = array_length(global.expressao_partes);

    if (_parentese == "(") {
        if (_qtd_partes <= 0) return true;

        var _ultima_abertura = global.expressao_partes[_qtd_partes - 1];
        return _ultima_abertura.tipo == "op" || (_ultima_abertura.tipo == "paren" && _ultima_abertura.valor == "(");
    }

    if (_parentese == ")") {
        if (contar_parenteses_abertos() <= 0 || _qtd_partes <= 0) return false;

        var _ultima_fechamento = global.expressao_partes[_qtd_partes - 1];
        return _ultima_fechamento.tipo == "carta" || (_ultima_fechamento.tipo == "paren" && _ultima_fechamento.valor == ")");
    }

    return false;
}

function expressao_valida() {
    if (!variable_global_exists("expressao_partes")) global.expressao_partes = [];

    var _qtd_partes = array_length(global.expressao_partes);
    if (_qtd_partes < 3) return false;

    var _max_cartas = max_cartas_por_numero();
    var _cartas_seguidas = 0;
    var _tem_operacao = false;
    var _espera_valor = true;
    var _parenteses_abertos = 0;
    var _tipo_anterior = "";
    var _valor_anterior = "";

    for (var i = 0; i < _qtd_partes; i++) {
        var _parte = global.expressao_partes[i];

        if (_parte.tipo == "carta") {
            if (_tipo_anterior == "paren" && _valor_anterior == ")") return false;

            _cartas_seguidas++;
            if (_cartas_seguidas > _max_cartas) return false;

            _espera_valor = false;
        } else if (_parte.tipo == "op") {
            if (_espera_valor) return false;

            _tem_operacao = true;
            _cartas_seguidas = 0;
            _espera_valor = true;
        } else if (_parte.tipo == "paren") {
            _cartas_seguidas = 0;

            if (_parte.valor == "(") {
                if (!_espera_valor) return false;

                _parenteses_abertos++;
                _espera_valor = true;
            } else {
                if (_espera_valor || _parenteses_abertos <= 0) return false;

                _parenteses_abertos--;
                _espera_valor = false;
            }
        } else {
            return false;
        }

        _tipo_anterior = _parte.tipo;
        _valor_anterior = _parte.valor;
    }

    return _tem_operacao && !_espera_valor && _parenteses_abertos == 0;
}

function aplicar_operacao_expressao(_resultado, _operacao, _num) {
    switch (_operacao) {
        case "+":    return _resultado + _num;
        case "-":    return _resultado - _num;
        case "*":    return _resultado * _num;
        case "/":    return (_num != 0) ? _resultado / _num : _resultado;
        case "^":    return power(_resultado, _num);
        case "sqrt": return sqrt(_num);
        case "log":  return logn(_num, _resultado);
    }

    return _resultado;
}

function calcular_grupo_expressao(_partes, _inicio) {
    var _resultado = 0;
    var _tem_resultado = false;
    var _operacao = "";
    var _i = _inicio;

    while (_i < array_length(_partes)) {
        var _parte = _partes[_i];

        if (_parte.tipo == "op") {
            _operacao = _parte.valor;
            _i++;
        } else if (_parte.tipo == "paren" && _parte.valor == ")") {
            return { valor: _resultado, indice: _i + 1 };
        } else {
            var _valor = 0;

            if (_parte.tipo == "paren" && _parte.valor == "(") {
                var _grupo = calcular_grupo_expressao(_partes, _i + 1);
                _valor = _grupo.valor;
                _i = _grupo.indice;
            } else {
                while (_i < array_length(_partes) && _partes[_i].tipo == "carta") {
                    _valor = _valor * 10 + _partes[_i].valor;
                    _i++;
                }
            }

            if (!_tem_resultado) {
                _resultado = _valor;
                _tem_resultado = true;
            } else {
                _resultado = aplicar_operacao_expressao(_resultado, _operacao, _valor);
            }
        }
    }

    return { valor: _resultado, indice: _i };
}

function calcular_resultado_expressao() {
    return calcular_grupo_expressao(global.expressao_partes, 0).valor;
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
        } else if (_parte.tipo == "op") {
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
        } else if (_parte.tipo == "op") {
            if (_texto != "") _texto += " ";
            _texto += string(_parte.valor);
            _ultima_foi_carta = false;
        } else if (_parte.tipo == "paren") {
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
