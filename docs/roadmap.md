# Studiositas — Roadmap do produto

Este documento descreve o percurso completo planejado para o Studiositas,
desde a preparação inicial até a visão ideal do produto. Ele deve ser usado
como um mapa de desenvolvimento entre diferentes etapas e conversas.

O roadmap representa a intenção atual do produto. As especificações de cada
etapa são a fonte de verdade para o comportamento detalhado. Caso uma decisão
altere o percurso, este documento deve ser atualizado.

## Como usar este documento

- Atualize o status de cada etapa quando ela for iniciada ou concluída.
- Registre links para specs, decisões técnicas e commits relevantes.
- Mantenha somente uma próxima etapa principal por vez.
- Não considere uma etapa concluída apenas porque a interface foi criada;
  regras, testes, persistência e critérios de aceitação também precisam estar
  validados.

## Status atual

### Estado geral

**Fase atual:** implementação da autenticação básica.

**Última etapa concluída:** estrutura inicial do projeto Flutter, constituição,
roadmap e validações puras do cadastro.

**Próxima etapa:** implementar o FirebaseAuthService, o AuthRepository e os
estados da ViewModel da autenticação.

**Branch de trabalho:** cada etapa deve criar uma nova branch a partir da
`main`, conforme definido em [`constitution.md`](../constitution.md).

## Visão final do produto

O Studiositas será uma rede social mobile de estudos na qual pessoas poderão:

- criar contas e perfis;
- criar grupos de estudos com período definido;
- convidar participantes por links temporários;
- registrar sessões de estudo com texto, duração, data, horário e foto;
- acompanhar os registros em uma timeline do grupo;
- reagir e comentar nas publicações;
- acompanhar a evolução do grupo;
- consultar a classificação final de um grupo encerrado;
- utilizar login social além de e-mail e senha;
- receber notificações e acompanhar metas e estatísticas em evoluções futuras.

## Percurso de desenvolvimento

### Fase 0 — Fundação e processo

**Status:** Concluída parcialmente

Objetivo: criar a base do projeto e estabelecer o processo SDD.

Entregas:

- [x] visão original do produto;
- [x] especificação inicial do MVP;
- [x] constituição do projeto;
- [x] decisões técnicas iniciais;
- [x] README do projeto;
- [x] repositório Git local;
- [x] repositório público no GitHub;
- [x] regra de branches por etapa;
- [x] estrutura inicial do projeto Flutter;
- [x] estrutura inicial de diretórios para MVVM;
- [x] roadmap do produto.

Referências:

- [`constitution.md`](../constitution.md)
- [`docs/visao-original.md`](visao-original.md)
- [`docs/decisoes-tecnicas.md`](decisoes-tecnicas.md)
- [`specs/001-mvp-grupos-e-checkins.md`](../specs/001-mvp-grupos-e-checkins.md)

### Fase 1 — Autenticação básica

**Status:** Em desenvolvimento

Objetivo: permitir que uma pessoa crie uma conta e acesse o aplicativo.

Escopo:

- cadastro com nome, e-mail, senha e telefone opcional;
- senha com os requisitos definidos na especificação;
- confirmação de senha;
- login com e-mail e senha;
- logout;
- restauração de sessão;
- proteção da área autenticada;
- tratamento de erros e indisponibilidade do Firebase;
- criação do perfil associado à conta de autenticação.

Referência: [`specs/002-autenticacao-email-senha.md`](../specs/002-autenticacao-email-senha.md)

Critério de conclusão:

- fluxo de autenticação funcional em ambiente local;
- regras de validação cobertas por testes;
- Firebase isolado em Services e Repositories;
- critérios de aceitação validados.

### Fase 2 — Criação e administração básica de grupos

**Status:** Planejada

Objetivo: permitir que um usuário autenticado crie e consulte seus grupos.

Escopo:

- criação de grupo;
- nome obrigatório;
- descrição;
- data inicial;
- data final;
- criador como primeiro participante;
- identificação do grupo;
- listagem de grupos dos quais o usuário participa;
- estado do grupo: planejado, ativo ou finalizado;
- validação do período;
- regras de autorização no Firebase.

Artefato esperado: `specs/003-criar-grupo.md`.

Critério de conclusão: um usuário autenticado consegue criar um grupo válido e
visualizá-lo na própria lista de grupos.

### Fase 3 — Convites e participação

**Status:** Planejada

Objetivo: permitir que participantes entrem em grupos com segurança.

Escopo:

- geração de código ou link de convite;
- validade de um dia;
- convite inválido ou expirado;
- entrada de usuário autenticado;
- prevenção de participação duplicada;
- visualização do grupo após entrada;
- regras para grupo finalizado;
- compartilhamento do convite pelo dispositivo.

Artefato esperado: `specs/004-convites-e-participacao.md`.

Critério de conclusão: uma pessoa autenticada consegue entrar em um grupo por
um convite válido, sem duplicar sua participação.

### Fase 4 — Check-ins de estudo

**Status:** Planejada

Objetivo: permitir que participantes registrem suas sessões de estudo.

Escopo:

- título obrigatório;
- descrição;
- duração em minutos;
- data e horário do estudo;
- check-in em qualquer horário enquanto o grupo estiver ativo;
- bloqueio após a data final do grupo;
- validação de duração e data;
- associação ao autor e ao grupo;
- persistência no Firebase.

Artefato esperado: `specs/005-checkins-de-estudo.md`.

Critério de conclusão: um participante consegue criar um check-in válido e ele
fica disponível para os participantes do grupo.

### Fase 5 — Timeline do grupo

**Status:** Planejada

Objetivo: apresentar os check-ins de forma clara e cronológica.

Escopo:

- timeline exclusiva para participantes;
- ordenação do mais recente para o mais antigo;
- identificação do autor;
- título, descrição, duração, data e horário;
- estados de carregamento, vazio e erro;
- atualização da timeline;
- paginação ou carregamento incremental quando necessário.

Artefato esperado: `specs/006-timeline-do-grupo.md`.

Critério de conclusão: participantes conseguem visualizar os check-ins do grupo
em uma timeline consistente e protegida.

### Fase 6 — Fotos nos check-ins

**Status:** Planejada

Objetivo: permitir que um check-in contenha uma evidência visual do estudo.

Escopo:

- seleção de foto do dispositivo;
- captura por câmera, se aplicável;
- preview antes do envio;
- upload para o Firebase Storage;
- associação da URL da foto ao check-in;
- estados de progresso, erro e cancelamento;
- limites de formato e tamanho;
- regras de acesso às imagens.

Artefato esperado: `specs/007-fotos-nos-checkins.md`.

Critério de conclusão: um participante consegue publicar um check-in com foto e
os demais participantes autorizados conseguem visualizá-la.

### Fase 7 — Interações sociais

**Status:** Planejada

Objetivo: permitir interação entre participantes por meio dos check-ins.

Escopo:

- reações disponíveis;
- adicionar e remover reação;
- contagem de reações;
- comentários;
- listagem de comentários;
- criação de comentário;
- regras de autorização;
- estados vazios, erros e carregamento;
- prevenção de conteúdo inválido ou vazio.

Artefatos esperados:

- `specs/008-reacoes.md`;
- `specs/009-comentarios.md`.

Critério de conclusão: participantes conseguem reagir e comentar em check-ins
de grupos dos quais participam.

### Fase 8 — Encerramento e classificação final

**Status:** Planejada

Objetivo: representar corretamente o encerramento de um grupo e seu resultado.

Escopo:

- bloqueio de novos check-ins após a data final;
- transição automática para grupo finalizado;
- preservação da timeline histórica;
- cálculo da classificação;
- definição dos critérios de classificação;
- total de tempo estudado;
- quantidade de check-ins;
- desempate;
- visualização da classificação final;
- tratamento de alterações de fuso horário e datas.

Artefato esperado: `specs/010-encerramento-e-classificacao.md`.

Critério de conclusão: um grupo finalizado não aceita novos registros e exibe
uma classificação final calculada por regras especificadas e testadas.

### Fase 9 — Login social

**Status:** Planejada

Objetivo: adicionar login social sem remover o acesso por e-mail e senha.

Escopo:

- login com Google;
- associação com conta existente;
- tratamento de cancelamento;
- tratamento de falha do provedor;
- atualização ou criação de perfil;
- regras de segurança;
- testes do fluxo de autenticação.

Artefato esperado: `specs/011-login-social.md`.

Critério de conclusão: uma pessoa consegue entrar por login social e acessar o
mesmo perfil e os mesmos grupos de uma conta existente.

### Fase 10 — Notificações, metas e estatísticas

**Status:** Planejada

Objetivo: aumentar a retenção e o acompanhamento da evolução dos estudos.

Possíveis entregas:

- notificações de convite;
- notificações de comentários e reações;
- metas individuais ou do grupo;
- sequência de dias estudados;
- total de horas;
- gráficos de evolução;
- ranking opcional durante o período do grupo;
- preferências de notificação.

Cada capacidade deverá receber uma especificação própria antes da
implementação.

### Fase 11 — Moderação, privacidade e robustez

**Status:** Planejada

Objetivo: preparar o produto para uso mais amplo e seguro.

Possíveis entregas:

- denúncia de conteúdo;
- bloqueio de usuário;
- remoção de comentários;
- administração de participantes;
- regras de privacidade;
- exclusão de conta;
- exportação ou remoção de dados;
- logs e monitoramento;
- tratamento de abuso;
- revisão das regras de segurança do Firebase.

### Fase 12 — Backend próprio em C#

**Status:** Planejada para estudo posterior

Objetivo: estudar a migração de uma solução backend gerenciada para um backend
próprio com Clean Architecture.

Escopo de estudo:

- backend em C# e ASP.NET Core;
- separação Domain, Application, Infrastructure e API;
- contratos e DTOs;
- autenticação e autorização;
- persistência em banco relacional;
- avaliação de Supabase/PostgreSQL e alternativas;
- migrations;
- testes unitários e de integração;
- documentação da API;
- substituição gradual dos Services Firebase no Flutter.

Esta fase não deve começar antes que o comportamento do produto esteja
estabilizado por especificações e testes. A arquitetura futura deve preservar
os contratos de negócio, permitindo comparar as duas implementações.

## Próximas etapas detalhadas

1. Configurar o projeto Flutter e suas dependências básicas.
2. Implementar e testar a validação de cadastro.
3. Criar o contrato do `AuthRepository`.
4. Criar o `FirebaseAuthService` isolado.
5. Implementar o fluxo de cadastro.
6. Implementar o fluxo de login.
7. Implementar restauração de sessão e logout.
8. Validar a especificação 002 e marcar a Fase 1 como concluída.
9. Criar a especificação 003 para criação de grupos.

## Registro de progresso

| Data | Etapa | Status | Observação |
|---|---|---|---|
| 2026-10-15 | Fundação do projeto | Concluída parcialmente | Projeto Flutter, SDD, Git e estrutura inicial criados. |
| 2026-10-15 | Validação de cadastro | Em preparação | Regras puras e testes iniciais criados. |
| 2026-10-15 | Roadmap | Concluída | Percurso completo documentado. |
| 2026-10-15 | Contrato de autenticação | Em desenvolvimento | Entidades de sessão/perfil e contrato do AuthRepository criados. |

## Convenção de status

- **Não iniciada:** ainda não houve trabalho na etapa.
- **Planejada:** etapa definida e aguardando sua vez.
- **Em preparação:** decisões, especificação ou estrutura inicial em andamento.
- **Em desenvolvimento:** implementação ativa na branch da etapa.
- **Em validação:** implementação concluída, aguardando testes ou revisão.
- **Concluída:** critérios e definição de pronto atendidos e etapa integrada à
  `main`.
- **Bloqueada:** depende de uma decisão ou mudança externa registrada.
