# Documentacao do projeto cpg-game

Este projeto e um jogo feito no GameMaker em que o jogador usa cartas numericas e operacoes matematicas para tentar derrotar inimigos. O fluxo principal acontece na sala `Room1`, que cria o objeto `obj_game`. A partir dele, o jogo cria o inimigo, a mao de cartas e os botoes de operacao.

## Fluxo geral

1. `Room1` inicia com uma instancia de `obj_game`.
2. `obj_game` inicializa as variaveis globais do jogo.
3. `obj_game` cria um `obj_enemy` no centro da sala.
4. `obj_game` cria um `obj_hand`, que monta a mao inicial com 5 cartas.
5. `obj_game` cria os botoes de operacao de acordo com a fase atual.
6. O jogador clica em uma ou mais cartas da mao e, se escolher mais de uma carta, tambem escolhe operacoes.
7. Ao clicar no botao `"="`, o jogo calcula o resultado.
8. O resultado positivo e subtraido da vida do inimigo.
9. Se a vida chegar a `0`, o inimigo morre.
10. Se o resultado nao derrotar o inimigo, o jogador perde uma tentativa.
11. Se as tentativas acabarem, a sala reinicia.

## Variaveis globais

As variaveis globais principais sao criadas em `objects/obj_game/Create_0.gml`.

| Variavel | Funcao |
| --- | --- |
| `global.fase` | Define a fase atual e quais operacoes ficam disponiveis. |
| `global.tentativas` | Quantidade de tentativas restantes contra o inimigo atual. |
| `global.carta_escolhida` | Guarda temporariamente a carta escolhida na tela de troca. |
| `global.jogo_pausado` | Impede a selecao normal da mao enquanto a tela de escolha esta aberta. |
| `global.mao` | Array global reservado para mao, mas a mao usada de fato fica em `obj_hand.mao`. |
| `global.cartas_selecionadas` | Valores das cartas selecionadas pelo jogador. |
| `global.indices_cartas_selecionadas` | Posicoes dessas cartas dentro da mao. |
| `global.ops_selecionadas` | Operacoes escolhidas entre as cartas. |

## `obj_game`

`obj_game` controla o inicio do jogo.

No evento Create, ele:

- define a fase inicial como `1`;
- define `3` tentativas;
- limpa arrays globais;
- cria o inimigo;
- cria a mao;
- cria os botoes de operacao.

No evento Step, ele verifica se a tecla espaco foi pressionada. Quando isso acontece e o jogo nao esta pausado, ele cria `obj_card_selection`, que abre uma selecao de 3 cartas para trocar uma carta da mao.

## `obj_hand`

`obj_hand` representa a mao do jogador.

No Create, ele cria um array chamado `mao` com 5 numeros aleatorios de `0` a `9`. Depois chama `atualizar_mao()`.

### `atualizar_mao()`

Essa funcao:

- destroi as cartas antigas da mao;
- mantem as cartas da tela de selecao, se houver;
- recria as cartas da mao na tela;
- define `numero`, `indice_mao` e `carta_selecao` em cada instancia de `obj_carta`.

### `substituir_carta(_numero)`

Essa funcao troca uma carta da mao pelo numero escolhido na tela de selecao. Ela usa o primeiro indice salvo em `global.indices_cartas_selecionadas`. Se nao houver carta selecionada, troca a carta da posicao `0`.

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

No Step, a carta calcula se o mouse esta sobre ela e faz uma animacao suave de subida.

No Mouse Left Pressed:

- se for uma carta de selecao, salva o valor em `global.carta_escolhida` e confirma a troca;
- se for uma carta da mao, alterna entre selecionada e nao selecionada;
- ao selecionar, adiciona o valor em `global.cartas_selecionadas`;
- ao selecionar, adiciona o indice em `global.indices_cartas_selecionadas`.

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
- substitui uma carta da mao pelo valor escolhido;
- limpa cartas e operacoes selecionadas;
- limpa `global.carta_escolhida`;
- destroi apenas as cartas temporarias de selecao;
- desmarca os botoes de operacao;
- despausa o jogo.

## `obj_btn_operacao`

`obj_btn_operacao` representa cada botao matematico.

Cada botao tem uma variavel `operacao`, definida quando `obj_game` cria os botoes. Os valores possiveis dependem da fase:

- fase 1: `+`, `-`, `=`;
- fase 2: `+`, `-`, `*`, `/`, `=`;
- fase 3: `+`, `-`, `*`, `/`, `log`, `^`, `sqrt`, `=`.

Quando o jogador clica em um botao que nao e `"="`, a operacao e adicionada em `global.ops_selecionadas`. Clicar novamente no mesmo botao remove essa operacao.

Quando o jogador clica em `"="`, o codigo valida:

- se ha pelo menos 1 carta;
- se a quantidade de operacoes e exatamente `quantidade de cartas - 1`;
- se existe um inimigo na sala.

Depois chama `calcular_resultado()`.

O resultado positivo vira dano e e subtraido da vida do inimigo. Se a vida chegar a `0`, o inimigo morre. Caso contrario, o jogador perde uma tentativa. Se as tentativas chegarem a `0`, chama `game_over()`.

## `obj_enemy`

`obj_enemy` representa o inimigo atual.

No Create:

- define `vida_max` com um valor aleatorio entre `10` e `20`;
- copia esse valor para `vida`.

No Step:

- se `vida <= 0`, chama `proximo_inimigo()`;
- depois destroi a instancia atual.

No Draw:

- desenha o sprite do inimigo;
- desenha o valor atual de `vida` acima dele.

## Scripts

### `operacoes_da_fase()`

Retorna o array de operacoes que deve aparecer como botoes na fase atual.

### `fases()`

Retorna operacoes parecidas com `operacoes_da_fase()`, mas sem o `"="`. No fluxo atual, quem e usado para criar botoes e `operacoes_da_fase()`.

### `calcular_resultado(_cartas, _ops)`

Recebe:

- `_cartas`: array com os valores das cartas selecionadas;
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

### `recomprar_cartas()`

Troca por numeros aleatorios apenas as cartas usadas na tentativa. Depois limpa:

- `global.cartas_selecionadas`;
- `global.indices_cartas_selecionadas`;
- `global.ops_selecionadas`.

### `proximo_inimigo()`

Reseta tentativas e selecoes, depois cria um novo `obj_enemy`.

### `game_over()`

Reinicia a sala atual com `room_restart()`.

### `globals`

Define o tamanho da janela com:

```gml
window_set_size(1280, 720);
```

## Objetos que existem, mas quase nao participam do fluxo atual

Alguns objetos estao no projeto, mas nao fazem parte do ciclo principal documentado acima:

- `obj_player`;
- `obj_ui`;
- `obj_operation`.

Eles podem ser usados futuramente, mas hoje o fluxo principal passa por `obj_game`, `obj_hand`, `obj_carta`, `obj_card_selection`, `obj_btn_operacao` e `obj_enemy`.

## Pontos de atencao

- `global.fase` inicia em `1`, mas o codigo atual nao avanca automaticamente para a fase `2` ou `3`.
- `global.mao` e criado, mas a mao usada fica no array local `mao` dentro de `obj_hand`.
- A tela de escolha troca a primeira carta selecionada. Se nenhuma carta estiver selecionada, troca a carta da posicao `0`.
- A sala `Room1` tem tamanho `320x180`, enquanto a janela e ajustada para `1280x720`.
