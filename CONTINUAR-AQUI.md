# CONTINUAR AQUI — Desafio Farol

> Handoff pra qualquer sessão do Claude Code. Idioma: português.
> Produto da **Farol Consultoria** (a MEI do Pedro). Nada aqui é da Metta: nome, textos,
> identidade, repositório e banco são próprios. Não misturar com as instâncias da Metta.

## 1. O que é

Quiz de treinamento em forma de jogo: pontuação por velocidade, pódio ao vivo e telão.
Multi-cliente: cada cliente da Farol é um *tenant* com logo, cor, lojas, perguntas e rodadas
próprias, escolhido pelo `?c=<slug>` no link. Começou **vazio** em 2026-11-18.

## 2. Onde está tudo

| O quê | Onde |
|---|---|
| Código | GitHub `PedroNavar/desafio-farol` (público: o GitHub Pages grátis exige) |
| Pasta no notebook | `pessoal\MEI\02. Construções com Agentes\desafio-farol\` |
| Site | `https://pedronavar.github.io/desafio-farol/` |
| Criar cliente novo | `https://pedronavar.github.io/desafio-farol/clientes.html` (senha master) |
| Supabase | projeto `desafio-farol` (`sgvxbdnbihgadmtijryp`), conta pessoal do Pedro, us-east-2, plano grátis |
| Edge Function | `https://sgvxbdnbihgadmtijryp.supabase.co/functions/v1/api/<rota>` |
| Publishable key (pública, vai no frontend) | `sb_publishable_dTf6RRb_SKNgs_kvotzxZw_GlaGdXVb` |
| Guia de uso (.docx, fora do git) | `pessoal\MEI\05. Documentos\Guia - Desafio Farol.docx` |

**Senhas:** nenhuma senha fica neste repositório. A senha master foi gerada e mostrada ao
Pedro uma vez, em chat, em 2026-11-18. As senhas de gerente e admin de cada cliente são
definidas por quem cria o cliente, na tela `clientes.html`.

**Plano grátis do Supabase:** o projeto pausa depois de 7 dias sem uso. Para reativar, abra
o painel do Supabase e clique em *Restore*.

## 3. Como usar

1. `clientes.html` → senha master → cria o cliente (nome, slug, URL da logo, cor, senha de
   gerente, senha de admin). Saem 4 links prontos com `?c=<slug>`.
2. Admin do cliente (`admin.html?c=<slug>`) → cadastra lojas e perguntas (em lote, por
   bloco), importa a lista de nomes e cria a rodada, que nasce travada.
3. Compartilha o link do jogo e do telão. Com todos a postos, "Começar para todos". Cada
   jogador recebe as perguntas numa ordem própria.
4. No fim: ranking, detalhe por jogador e exportação em CSV ou Excel.

Sem `?c=` o backend responde "Cliente não encontrado": não existe cliente padrão.
O telão só mostra o pódio a partir do próximo evento da rodada (alguém entra ou responde),
então abra o telão antes de começar.

## 4. Identidade

Paleta, fontes e logo vêm do kit da marca (`MEI\04. Marca`, os mesmos tokens da skill
`farol-pdf`): fundo marinho `#002464`, destaque luz `#90C0F8` (texto marinho sobre ele),
médio `#1F5FD1` no fio do cabeçalho, névoa `#E8F0FC` no admin. Títulos em Archivo, texto
em Atkinson Hyperlegible (as duas SIL OFL, licenças em `frontend/fonts/`). Logo:
`frontend/img/logo-farol.png`, a versão negativa oficial só recortada e reduzida, nunca
recolorida. A cor do cliente substitui `--destaque`; a logo do cliente aparece à esquerda
do cabeçalho e some quando o cliente não tem logo.

## 5. Como operar o Supabase

- A CLI roda via `npx --yes supabase ...`, de dentro desta pasta. O login global da CLI nesta
  máquina é a conta pessoal do Pedro, a mesma deste projeto: não precisa de token extra.
- Mudança de banco = nova migration em `supabase/migrations/<timestamp>_nome.sql`, depois
  `db push --remote --yes`.
- Deploy da função: `functions deploy api --no-verify-jwt --yes` (o `--no-verify-jwt` é
  obrigatório: o jogador usa token próprio, não JWT do Supabase).
- Migration que define senha: aplicar com o valor e **redigir o arquivo** antes do commit.
- Apagar um cliente: primeiro as rodadas dele (`rodada_pergunta` aponta pra `pergunta` sem
  cascade), depois o tenant. Exemplo em `20261118232000_limpar_teste_site.sql`.
- Há um pre-commit hook de segurança global que barra commit com cara de segredo.

## 6. GitHub

- `gh` nesta máquina tem as contas `PedroNavar` e `Metta-Brasil`. Antes de push aqui:
  `gh auth switch --user PedroNavar`.
- Esta pasta tem `credential.helper` apontando pro `gh` (`git config --local`) e autoria
  `PedroNavar <97485113+PedroNavar@users.noreply.github.com>`.
- Deploy do site é automático (`.github/workflows/pages.yml`) a cada push em `frontend/`.
- Se a Farol ganhar conta própria no GitHub, transferir o repositório mantém o histórico;
  o endereço do site muda junto.

## 7. Limitações conhecidas

- Logo do cliente é URL de imagem (sem upload).
- O título da aba não troca por cliente.
- Admin sem sessão: a senha vai em cada chamada; o link do CSV/Excel leva a senha na URL.
- Pódio "por loja" ainda calcula o top-3 geral.

## 8. Regras do jogo que o backend garante

1. O gabarito só fica no servidor (aparece só pro admin, no detalhe por jogador).
2. Pontuação de 500 a 1000 por velocidade; 0 se erra ou se o tempo acaba.
3. A lista de perguntas congela na entrada do primeiro jogador; cada jogador tem ordem própria.
4. Rodada encerrada não reabre. 5. Resposta repetida é recusada.
6. Nome único por rodada (o admin pode liberar). 7. Regional e Outro jogam, mas não entram no
   pódio. 8. Tudo separado por cliente.
