# Documentacao do projeto cpg-game

Este projeto e um jogo feito no GameMaker em que o jogador usa cartas numericas e operacoes matematicas para atacar a vida do inimigo. O fluxo principal acontece na sala `Room1`, que cria o objeto `obj_game`. A partir dele, o jogo inicializa variaveis globais, cria os inimigos, cria a mao de cartas e cria os botoes de operacao.

## Fluxo geral

1. `Room1` inicia com uma instancia de `obj_game`.
2. `obj_game` inicializa as variaveis globais do jogo.
3. `obj_game` chama `criar_inimigos()`, que monta os sprites do inimigo e calcula `global.enemy_life`.
4. `obj_game` cria um `obj_hand`, que monta a mao inicial com 5 cartas.
5. `obj_game` cria os botoes de operacao da fase atual.
6. `obj_game` cria um botao extra de reroll com `operacao = "REROLL"`.
7. O jogador seleciona cartas da mao e operacoes.
8. Ao clicar no botao `"="`, o jogo exige pelo menos 2 cartas e pelo menos 1 operacao.
9. O resultado positivo vira dano e e subtraido de `global.enemy_life`.
10. Se a vida chegar a `0`, as cartas usadas sao recompradas e `proximo_inimigo()` cria a proxima rodada.
11. Se o jogador acertar exatamente o valor da vida do inimigo, ganha `+1` tentativa na proxima rodada.
12. A barra superior de progressao avanca um ponto a cada inimigo morto.
13. Ao derrotar o ponto grande, que representa o boss, a fase avanca e os botoes de operacao sao recriados.
14. Ao passar de fase, o jogo pausa e abre 3 cartas rogue-like para o jogador escolher 1.
15. Se o resultado nao derrotar o inimigo, o jogador perde uma tentativa.
16. Se as tentativas acabarem, `game_over()` reinicia a sala.

## Variaveis globais

As variaveis globais principais sao criadas em `objects/obj_game/Create_0.gml` e `scripts/globals/globals.gml`.

| Variavel | Funcao |
| --- | --- |
| `global.fase` | Define a fase atual e quais operacoes ficam disponiveis. |
| `global.enemy_life` | Vida atual do inimigo. Tambem representa o numero formado pelos sprites dos inimigos. |
| `global.tentativas` | Quantidade de tentativas restantes contra o inimigo atual. |
| `global.bonus_tentativas_proxima` | Guarda o bonus de tentativa quando o jogador mata com resultado exato. |
| `global.cargas_reroll_mao` | Quantidade de rerolls restantes na fase atual. Comeca com `2`. |
| `global.fase_reroll_mao` | Fase usada para saber quando as cargas de reroll precisam resetar. |
| `global.ui_top_space` | Reserva `50` pixels no topo da sala para UI e desloca a area jogavel para baixo. |
| `global.inimigos_por_fase` | Quantidade de encontros na barra de progressao. Usa `4`: tres inimigos comuns e um boss. |
| `global.inimigo_atual_fase` | Indice atual da progressao da fase. Cada morte aumenta esse valor. |
| `global.fase_maxima` | Ultima fase que o jogo pode alcancar automaticamente. |
| `global.precisa_atualizar_botoes` | Sinaliza para o `obj_game` recriar os botoes quando a fase muda. |
| `global.bonus_cargas_reroll_mao` | Bonus permanente de cargas de reroll dado pela carta `Mao Nova`. |
| `global.bonus_precisao` | Bonus permanente para acerto exato dado pela carta `Precisao`. |
| `global.bonus_cartas_seguidas_temporario` | Bonus temporario no limite de cartas grudadas dado pela carta `Numero Grudado`. |
| `global.fase_bonus_numero_grudado` | Fase em que o bonus temporario de `Numero Grudado` esta ativo. |
| `global.usos_coringa_numerico_por_rodada` | Quantas vezes o Coringa Numerico pode ser usado por rodada. |
| `global.usos_coringa_numerico_rodada` | Quantas vezes o Coringa Numerico ja foi usado na rodada atual. |
| `global.recompensa_roguelike_aberta` | Indica se a tela de escolha rogue-like esta aberta. |
| `global.roguelike_opcoes` | Array com as 3 cartas sorteadas na recompensa atual. |
| `global.carta_escolhida` | Guarda temporariamente a carta escolhida na tela de troca. |
| `global.jogo_pausado` | Impede selecao normal da mao e reroll enquanto a tela de escolha esta aberta. |
| `global.mao` | Array global reservado para mao, mas a mao usada de fato fica em `obj_hand.mao`. |
| `global.cartas_selecionadas` | Valores das cartas selecionadas pelo jogador. |
| `global.indices_cartas_selecionadas` | Posicoes dessas cartas dentro da mao. |
| `global.ops_selecionadas` | Operacoes escolhidas entre as cartas. |
| `global.expressao_partes` | Guarda a ordem real dos cliques da expressao, misturando cartas e operacoes. |

## `obj_game`

`obj_game` controla o inicio do jogo.

No evento Create, ele:

- define a fase inicial como `1`;
- define as tentativas com `tentativas_base_fase()`;
- inicia `global.bonus_tentativas_proxima` com `0`;
- inicia `global.cargas_reroll_mao` com `2`;
- define `global.ui_top_space = 50` para deixar espaco livre para UI no topo;
- inicia a progressao de fase com `4` encontros, sendo o ultimo o boss;
- chama `resetar_roguelike()` para zerar bonus de uma run anterior;
- chama `inicializar_roguelike()` para preparar os bonus rogue-like;
- limpa arrays globais de selecao;
- chama `criar_inimigos()`;
- cria a mao;
- cria os botoes de operacao com `criar_botoes_operacao()`;
- cria o botao de reroll;
- cria o botao de limpar expressao.

O botao de reroll e criado assim:

```gml
var _btn_reroll      = instance_create_layer(room_width - 40, 320 + global.ui_top_space, "Instances", obj_btn_operacao);
_btn_reroll.operacao = "REROLL";

var _btn_clear      = instance_create_layer(room_width - 95, 320 + global.ui_top_space, "Instances", obj_btn_operacao);
_btn_clear.operacao = "CLEAR";
```

No evento Draw, `obj_game` desenha uma moldura branca ao redor da arena de luta, pegando player e inimigos. A mesma rotina desenha o display entre a arena e a mao. A arena e o display usam `global.ui_top_space` para ficarem abaixo da UI superior. Esse display monta o texto usando `global.expressao_partes`, respeitando a ordem real dos cliques.

Exemplo:

```text
7 + 2
```

No evento Step existe um trecho comentado que abriria `obj_card_selection` ao pressionar espaco. No estado atual, essa tela de troca so funciona se esse gatilho for religado ou chamado por outro lugar.

O Step tambem confere `global.precisa_atualizar_botoes`. Quando essa flag fica verdadeira, `obj_game` chama `criar_botoes_operacao()` para destruir os botoes antigos e recriar as operacoes da nova fase.

## `obj_ui`

`obj_ui` desenha a UI superior.

Ele mostra:

- o circulo vermelho de tentativas no canto esquerdo;
- a barra laranja de progressao da fase;
- pontos pequenos para inimigos comuns;
- um ponto grande no final para o boss;
- uma borda branca no ponto atual.

A barra usa `global.inimigos_por_fase` e `global.inimigo_atual_fase`. Quando `global.inimigo_atual_fase` aumenta, o ponto ativo anda para a direita.

## `obj_hand`

`obj_hand` representa a mao do jogador.

No Create, ele cria um array local chamado `mao` com 5 cartas aleatorias e depois chama `atualizar_mao()`.

A mao tem uma regra importante: ela nao pode ficar com 3 cartas iguais. Para isso, `obj_hand` tem funcoes auxiliares:

| Funcao | Funcao no jogo |
| --- | --- |
| `contar_cartas_iguais(_numero, _indice_ignorado)` | Conta quantas cartas iguais existem, ignorando uma posicao especifica. |
| `pode_receber_carta(_numero, _indice_ignorado)` | Retorna se a carta pode entrar sem formar 3 iguais. |
| `comprar_carta_valida(_indice_ignorado)` | Sorteia uma carta de `0` a `9` que respeita a regra de no maximo 2 iguais. |
| `substituir_carta(_numero)` | Troca uma carta selecionada por outra, protegendo a regra de cartas iguais. |

Na fase 1, `comprar_carta_valida()` sorteia apenas de `1` a `9`, evitando que a mao inicial venha fraca demais com cartas `0`.

### `atualizar_mao()`

Essa funcao:

- destroi as cartas antigas da mao;
- mantem cartas temporarias da tela de selecao, se houver;
- recria as cartas da mao na tela;
- define `numero`, `indice_mao`, `carta_selecao` e `image_index` em cada instancia de `obj_carta`.

## `obj_carta`

`obj_carta` e usado em dois contextos:

- carta normal da mao;
- carta temporaria da tela de selecao.

As variaveis principais sao:

| Variavel | Funcao |
| --- | --- |
| `numero` | Valor da carta. Tambem define o frame do sprite. |
| `selecionada` | Indica se a carta esta selecionada. |
| `hover` | Indica se o mouse esta sobre a carta. |
| `y_offset` | Controla a animacao vertical ao passar o mouse. |
| `indice_mao` | Posicao da carta dentro da mao. |
| `carta_selecao` | Define se a carta pertence a tela de selecao. |

No Mouse Left Pressed:

- se for carta de selecao, salva `global.carta_escolhida` e chama `confirmar()`;
- se for carta da mao, alterna entre selecionada e nao selecionada;
- ao selecionar, adiciona valor em `global.cartas_selecionadas`;
- ao selecionar, adiciona posicao em `global.indices_cartas_selecionadas`;
- ao selecionar, adiciona uma parte do tipo `"carta"` em `global.expressao_partes`;
- antes de selecionar, chama `pode_adicionar_carta_expressao()` para respeitar o limite de cartas por numero da fase.
- se o jogador tiver `Coringa Numerico`, pode segurar `Shift` ao clicar em uma carta da mao para abrir a escolha de valor `0` a `9`.

## `obj_card_selection`

`obj_card_selection` abre uma tela temporaria com 3 cartas aleatorias.

No Create, ele:

- cria um array com numeros de `0` a `9`;
- sorteia 3 numeros sem repetir;
- cria 3 instancias de `obj_carta`;
- marca essas cartas com `carta_selecao = true`.

### `confirmar()`

Essa funcao e chamada quando o jogador clica em uma carta da selecao.

Ela:

- encontra `obj_hand`;
- chama `_hand.substituir_carta(global.carta_escolhida)`;
- limpa cartas e operacoes selecionadas;
- limpa `global.carta_escolhida`;
- destroi as cartas temporarias de selecao;
- desmarca os botoes de operacao;
- despausa o jogo.

## `obj_recompensa_roguelike`

`obj_recompensa_roguelike` desenha a tela de recompensa ao passar de fase.

Ele:

- escurece a tela;
- mostra 3 cartas sorteadas em `global.roguelike_opcoes`;
- aplica a carta clicada com `aplicar_carta_roguelike(_id)`;
- fecha a recompensa com `fechar_recompensa_roguelike()`;
- despausa o jogo depois da escolha.

Cartas atuais:

| Carta | Efeito |
| --- | --- |
| `Mao Nova` | Aumenta as cargas de reroll por fase e soma `+1` imediatamente em `global.cargas_reroll_mao`. |
| `Precisao` | Aumenta em `+1` o bonus de tentativa quando o jogador mata com resultado exato. |
| `Numero Grudado` | Durante a fase atual, aumenta em `+1` o limite de cartas seguidas para formar numero. |
| `Coringa Numerico` | Permite usar `Shift + clique` em uma carta por rodada para escolher um valor de `0` a `9`. |

## `obj_coringa_escolha`

`obj_coringa_escolha` abre quando o jogador usa o `Coringa Numerico`.

Ele:

- pausa o jogo;
- desenha botoes de `0` a `9`;
- troca o valor daquela parte em `global.expressao_partes`;
- marca a carta visualmente com `image_blend = c_aqua`;
- consome 1 uso de coringa da rodada;
- despausa o jogo depois da escolha.

## `obj_btn_operacao`

`obj_btn_operacao` representa tanto botoes matematicos quanto o botao de reroll.

Cada botao tem uma variavel `operacao`, definida quando `obj_game` cria os botoes.

No Draw, os botoes `+`, `-`, `*` e `/` usam o sprite `spr_operations`:

| Operacao | Frame de `spr_operations` |
| --- | --- |
| `+` | `0` |
| `-` | `1` |
| `*` | `2` |
| `/` | `3` |

Os botoes que ainda nao tem sprite proprio continuam em texto, como `(`, `)`, `=`, `C`, `R2`, `log`, `^` e `sqrt`.

Operacoes por fase:

| Fase | Operacoes |
| --- | --- |
| `1` | `+`, `-`, `=` |
| `2` | `+`, `-`, `*`, `/`, `=` |
| `3` | `(`, `)`, `+`, `-`, `*`, `/`, `log`, `^`, `sqrt`, `=` |

### Botao `"="`

Quando o jogador clica em uma operacao comum, como `+` ou `*`, o botao primeiro chama `pode_adicionar_operacao_expressao()`. Isso impede operacao antes de carta e impede duas operacoes seguidas. Se puder adicionar, a operacao entra em `global.ops_selecionadas` e tambem em `global.expressao_partes`.

Na fase 3, os botoes `(` e `)` usam `pode_adicionar_parentese_expressao()` para garantir que parenteses abrem antes de um valor, fecham depois de um valor e nunca ficam desbalanceados.

Quando o jogador clica em `"="`, o codigo valida:

- se a expressao comeca e termina com carta;
- se existe pelo menos 1 operacao;
- se nao existem duas operacoes seguidas;
- se a quantidade de cartas seguidas por numero respeita a fase;
- se existe um `obj_enemy` na sala.

Depois chama `calcular_resultado_expressao()`.

Regras de cartas por numero:

| Fase | Regra |
| --- | --- |
| `1` | Cada numero pode ter apenas 1 carta. Permite `9 * 2`, mas bloqueia `90 * 2`. |
| `2` e `3` | Cada numero pode ter ate 2 cartas. Permite `90 * 2`, `9 * 2` ou `90 * 23`. |

Se o resultado for positivo, ele vira dano em `global.enemy_life`. Se `global.enemy_life` chegar a `0`, o jogo:

- verifica se o resultado foi exatamente igual a vida anterior;
- adiciona `1 + global.bonus_precisao` em `global.bonus_tentativas_proxima` se foi exato;
- chama `recomprar_cartas()`;
- chama `proximo_inimigo()`.

Se o inimigo sobreviver, o jogador perde uma tentativa. Se ainda houver tentativas, as cartas usadas sao recompradas. Se as tentativas acabarem, `game_over()` reinicia a sala.

### Botao `"REROLL"`

O botao de reroll tambem e um `obj_btn_operacao`, mas recebe:

```gml
operacao = "REROLL";
```

No Mouse Left Pressed, antes das operacoes normais, ele faz:

```gml
if (operacao == "REROLL") {
    rerrolar_mao();
    exit;
}
```

No Draw, esse botao mostra:

- `R2`, quando ainda tem 2 cargas;
- `R1`, quando ainda tem 1 carga;
- `R0`, quando acabou.

Quando acaba a carga, o botao fica cinza.

### Botao `"CLEAR"`

O botao de limpar tambem e um `obj_btn_operacao`, mas recebe:

```gml
operacao = "CLEAR";
```

No Draw, esse botao aparece como `C`. Ao clicar, ele chama `limpar_expressao()`, que:

- limpa `global.cartas_selecionadas`;
- limpa `global.indices_cartas_selecionadas`;
- limpa `global.ops_selecionadas`;
- limpa `global.expressao_partes`;
- desmarca cartas da mao;
- desmarca botoes de operacao.

## `obj_enemy`

`obj_enemy` representa visualmente os digitos da vida do inimigo.

Cada instancia usa um sprite de `spr_enemy_0` ate `spr_enemy_9`. Cada inimigo representa um digito de `global.enemy_life`.

No Create, o objeto monta o array `sprites_enemy` e cria o metodo de instancia `definir_numero_enemy(_numero, _posicao)`:

```gml
definir_numero_enemy = function(_numero, _posicao) {
    digito_posicao = _posicao;
    numero_enemy = _numero;
    sprite_index = sprites_enemy[numero_enemy];
    image_index = 0;
    image_speed = 0;
};
```

Esse metodo guarda:

- `numero_enemy`: o digito mostrado por aquela instancia;
- `digito_posicao`: a posicao decimal que ela representa, como unidade, dezena ou centena;
- `sprite_index`: o sprite correspondente ao digito.

O script `criar_inimigos()` cria `global.fase + 1` inimigos, da direita para a esquerda, e soma os valores em `global.enemy_life` usando potencias de 10:

```gml
global.enemy_life += _numero * power(10, i);
```

Assim:

- o inimigo da posicao `0` representa unidade;
- o inimigo da posicao `1` representa dezena;
- o inimigo da posicao `2` representa centena.

No Step, cada inimigo recalcula o digito que deve mostrar com base na vida atual:

```gml
var _peso = power(10, digito_posicao);
var _numero_atual = floor(global.enemy_life / _peso) mod 10;

definir_numero_enemy(_numero_atual, digito_posicao);
visible = (digito_posicao == 0 || global.enemy_life >= _peso);
```

Isso faz os sprites acompanharem a vida quando o jogador causa dano. Se a vida cair de `52` para `8`, por exemplo, o digito da dezena fica invisivel e sobra so a unidade.

## Scripts

### `operacoes_da_fase()`

Retorna o array de operacoes que deve aparecer como botoes na fase atual.

### `fases()`

Retorna operacoes parecidas com `operacoes_da_fase()`, mas sem o `"="`. No fluxo atual, quem cria os botoes usa `operacoes_da_fase()`.

### `calcular_resultado(_cartas, _ops)`

Calcula um resultado a partir de arrays ja separados em numeros e operacoes.

Recebe:

- `_cartas`: array com os numeros que entram no calculo;
- `_ops`: array com as operacoes selecionadas.

Ele comeca com a primeira carta e aplica cada operacao usando a proxima carta.

Exemplo:

```gml
_cartas = [3, 5, 2];
_ops = ["+", "*"];
```

O calculo feito sera:

```text
3 + 5 = 8
8 * 2 = 16
```

Operacoes suportadas:

| Operacao | Efeito |
| --- | --- |
| `+` | Soma. |
| `-` | Subtracao. |
| `*` | Multiplicacao. |
| `/` | Divisao, ignorando divisao por zero. |
| `^` | Potencia. |
| `sqrt` | Raiz quadrada do proximo numero. |
| `log` | Logaritmo usando `logn(_num, _resultado)`. |
| `(` e `)` | Agrupam parte da expressao a partir da fase 3. |

### Funcoes de expressao

Essas funcoes tambem ficam em `scripts/calcular_resultados/calcular_resultados.gml`.

| Funcao | Funcao no jogo |
| --- | --- |
| `max_cartas_por_numero()` | Retorna `1` na fase 1 e `2` nas fases 2 e 3. |
| `pode_adicionar_carta_expressao()` | Bloqueia cartas seguidas acima do limite da fase. |
| `pode_adicionar_operacao_expressao()` | Permite operacao apenas depois de uma carta. |
| `pode_adicionar_parentese_expressao(_parentese)` | Valida abertura e fechamento de parenteses. |
| `contar_parenteses_abertos()` | Conta quantos parenteses ainda estao abertos na expressao. |
| `expressao_valida()` | Confere se a expressao esta pronta para calcular. |
| `calcular_grupo_expressao(_partes, _inicio)` | Calcula grupos entre parenteses de forma recursiva. |
| `calcular_resultado_expressao()` | Monta numeros com cartas seguidas e calcula o resultado final, respeitando parenteses. |
| `remover_expressao_a_partir(_inicio)` | Remove uma parte da expressao e tudo que veio depois dela. |
| `limpar_expressao()` | Limpa toda a expressao e desmarca cartas e operacoes. |
| `montar_texto_expressao(_mostrar_resultado)` | Gera o texto usado pelo display da expressao. |

`Numero Grudado` aumenta temporariamente o retorno de `max_cartas_por_numero()` em `+1` durante a fase em que a carta foi escolhida.

Exemplos:

```text
fase 1: 9 + 2  -> valido
fase 1: 9 * 2  -> bloqueado porque multiplicacao so aparece a partir da fase 2
fase 1: 90 * 2 -> bloqueado
fase 2: 90 * 2 -> valido
fase 3: 2 * (3 + 4) -> valido
```

### `recomprar_cartas()`

Troca apenas as cartas usadas na tentativa.

Ela:

- encontra `obj_hand`;
- percorre `global.indices_cartas_selecionadas`;
- usa `_hand.comprar_carta_valida(_idx)` para repor cada carta;
- chama `_hand.atualizar_mao()`;
- limpa cartas e operacoes selecionadas.

### `rerrolar_mao()`

Troca a mao inteira e consome 1 carga de reroll.

Ela:

- garante que as globais de reroll existem;
- reseta as cargas para `cargas_reroll_maximas()` se `global.fase` mudou;
- retorna `false` se o jogo esta pausado ou se as cargas acabaram;
- troca todas as cartas da mao usando `_hand.comprar_carta_valida(i)`;
- diminui `global.cargas_reroll_mao`;
- limpa cartas e operacoes selecionadas;
- desmarca botoes;
- atualiza a mao;
- retorna `true` quando o reroll acontece.

### `tentativas_base_fase()`

Retorna a quantidade base de tentativas por fase.

No balanceamento atual:

| Fase | Tentativas base |
| --- | --- |
| `1` | `4` |
| `2` e `3` | `3` |

### `sortear_vida_inimigo()`

Sorteia a vida do inimigo por faixa de dificuldade, usando `global.fase` e `global.inimigo_atual_fase`.

Na fase 1, o primeiro inimigo fica entre `10` e `18` de vida, os inimigos seguintes ficam entre `16` e `28`, e o boss fica entre `30` e `45`.

### `criar_inimigos()`

Fica em `scripts/proximo_inimigo/proximo_inimigo.gml`.

Essa funcao:

- define `global.enemy_life` usando `sortear_vida_inimigo()`;
- calcula a quantidade de inimigos com `global.fase + 1`;
- quebra `global.enemy_life` em digitos;
- cria uma instancia de `obj_enemy` por digito;
- posiciona os inimigos usando `100 + global.ui_top_space`, mantendo a area superior livre para UI;
- chama `_enemy.definir_numero_enemy(_numero, i)` para configurar o digito da instancia;
- esconde digitos altos quando a vida nao precisa deles.

### `proximo_inimigo()`

Tambem fica em `scripts/proximo_inimigo/proximo_inimigo.gml`.

Essa funcao:

- destroi inimigos antigos;
- avanca `global.inimigo_atual_fase`;
- se o ponto atual passar do ultimo ponto, reseta a progressao e avanca `global.fase`;
- marca `global.precisa_atualizar_botoes = true` quando a fase muda;
- limpa bonus temporarios da fase anterior;
- reseta usos de Coringa Numerico da rodada;
- aplica `global.bonus_tentativas_proxima` nas tentativas;
- zera o bonus;
- limpa selecoes;
- chama `criar_inimigos()`;
- se a fase mudou, chama `abrir_recompensa_roguelike()`.

### `roguelike_cartas`

Fica em `scripts/roguelike_cartas/roguelike_cartas.gml`.

Funcoes principais:

| Funcao | Funcao no jogo |
| --- | --- |
| `inicializar_roguelike()` | Garante que todas as globais rogue-like existem. |
| `resetar_roguelike()` | Zera cartas e bonus rogue-like no inicio de uma run. |
| `cargas_reroll_maximas()` | Retorna `2 + global.bonus_cargas_reroll_mao`. |
| `sortear_opcoes_roguelike(_qtd)` | Sorteia cartas sem repetir dentro da mesma oferta e evita cartas ja escolhidas enquanto houver opcoes novas. |
| `abrir_recompensa_roguelike()` | Pausa o jogo e cria `obj_recompensa_roguelike`. |
| `aplicar_carta_roguelike(_id)` | Aplica o efeito da carta escolhida. |
| `fechar_recompensa_roguelike()` | Fecha a recompensa e despausa o jogo. |
| `resetar_roguelike_por_rodada()` | Reseta usos de Coringa Numerico no inicio de cada inimigo. |

### `game_over()`

Reinicia a sala atual com `room_restart()`.

### `globals`

Define o tamanho da janela e inicia a vida global do inimigo:

```gml
window_set_size(1760, 990);
global.enemy_life = 0;
```

## Objetos que existem, mas quase nao participam do fluxo atual

Alguns objetos estao no projeto, mas nao fazem parte do ciclo principal documentado acima:

- `obj_player`;
- `obj_operation`.

Eles podem ser usados futuramente, mas hoje o fluxo principal passa por `obj_game`, `obj_ui`, `obj_hand`, `obj_carta`, `obj_card_selection`, `obj_recompensa_roguelike`, `obj_coringa_escolha`, `obj_btn_operacao` e `obj_enemy`.

## Pontos de atencao

- `global.fase` inicia em `1` e avanca depois que o boss da barra de progressao e derrotado.
- `global.mao` e criado, mas a mao usada fica no array local `mao` dentro de `obj_hand`.
- A tela de escolha depende de um gatilho. O trecho do espaco em `obj_game/Step_0.gml` esta comentado.
- `criar_inimigos()` depende do metodo `definir_numero_enemy` criado no Create de `obj_enemy`.
- A sala `Room1` tem tamanho `500x400`, enquanto a janela e ajustada para `1760x990`.
- Os primeiros `50` pixels da sala ficam reservados para UI superior. Player, inimigos, arena, display, mao e botoes sao deslocados usando `global.ui_top_space`.
