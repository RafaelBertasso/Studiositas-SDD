# Studiositas — especificação 001: MVP de grupos e check-ins

## Status

Proposta

## Objetivo

Entregar uma primeira versão demonstrável da rede social de estudos na qual
usuários possam criar um grupo, convidar outra pessoa por meio de um link e
publicar check-ins de estudo em uma timeline do grupo.

## Escopo

### Incluído

- Criar um grupo de estudos.
- Definir nome, descrição, data inicial e data final do grupo.
- Gerar um link de convite para o grupo.
- Entrar em um grupo usando o link de convite.
- Criar check-ins dentro de um grupo do qual o usuário participa.
- Exibir os check-ins em ordem cronológica na timeline do grupo.
- Identificar o autor de cada check-in.

### Não incluído

- Upload e exibição de fotos.
- Reações.
- Comentários.
- Notificações.
- Ranking ou gamificação.
- Metas e estatísticas.
- Grupos públicos.
- Moderação.
- Edição e exclusão de grupos ou check-ins.
- Recuperação de senha e autenticação completa.

## Conceitos principais

### Usuário

Pessoa que utiliza o sistema. Nesta primeira etapa, a identificação do usuário
pode ser simplificada, desde que seja possível distinguir o criador do grupo,
os participantes e os autores dos check-ins.

### Grupo de estudos

Espaço com período definido no qual participantes compartilham seus estudos.

Campos mínimos:

- `id`
- `nome`
- `descricao`
- `data_inicio`
- `data_fim`
- `criador_id`
- `codigo_convite`
- `criado_em`

### Participação

Relacionamento entre um usuário e um grupo.

Campos mínimos:

- `usuario_id`
- `grupo_id`
- `entrou_em`

### Check-in

Registro de uma sessão de estudo publicada por um participante.

Campos mínimos:

- `id`
- `grupo_id`
- `autor_id`
- `titulo`
- `descricao`
- `duracao_minutos`
- `estudado_em`
- `criado_em`

## Regras de negócio

1. O nome do grupo é obrigatório.
2. A data inicial é obrigatória.
3. A data final é obrigatória.
4. A data final não pode ser anterior à data inicial.
5. O criador do grupo deve ser incluído automaticamente como participante.
6. Cada grupo deve possuir um código de convite único.
7. Um usuário não deve ser incluído duas vezes no mesmo grupo.
8. Apenas participantes podem visualizar a timeline do grupo.
9. Apenas participantes podem criar check-ins no grupo.
10. O título do check-in é obrigatório.
11. A duração do estudo deve ser maior que zero minuto.
12. O check-in deve registrar o usuário autor e o grupo ao qual pertence.
13. A timeline deve exibir os check-ins do mais recente para o mais antigo.
14. Um check-in criado fora do período do grupo não deve ser aceito.

## Fluxos principais

### Fluxo 1 — Criar grupo

1. O usuário acessa a opção de criar grupo.
2. Informa nome, descrição, data inicial e data final.
3. O sistema valida os dados.
4. O sistema cria o grupo.
5. O sistema inclui o usuário como participante.
6. O sistema gera um link de convite.
7. O sistema apresenta o grupo e o link de convite.

### Fluxo 2 — Entrar por convite

1. O usuário acessa um link de convite válido.
2. O sistema identifica o grupo.
3. O sistema inclui o usuário como participante.
4. O sistema apresenta a timeline do grupo.

### Fluxo 3 — Publicar check-in

1. O participante acessa a área de criação de check-in.
2. Informa título, descrição, duração e data/horário do estudo.
3. O sistema valida os dados e a participação no grupo.
4. O sistema cria o check-in.
5. O sistema exibe o check-in na timeline do grupo.

## Critérios de aceitação

### Cenário 1 — Grupo criado com sucesso

**Dado** que um usuário forneça nome, descrição, data inicial e data final válidos

**Quando** confirmar a criação do grupo

**Então** o grupo deve ser criado

**E** o usuário deve se tornar participante do grupo

**E** deve ser gerado um link de convite utilizável

### Cenário 2 — Período inválido

**Dado** que um usuário informe uma data final anterior à data inicial

**Quando** tentar criar o grupo

**Então** o grupo não deve ser criado

**E** o sistema deve informar que o período é inválido

### Cenário 3 — Entrada por convite

**Dado** que exista um link de convite válido

**Quando** um usuário ainda não participante acessar o link

**Então** o usuário deve ser incluído no grupo

**E** deve conseguir visualizar a timeline do grupo

### Cenário 4 — Convite já utilizado pelo participante

**Dado** que um usuário já participe do grupo

**Quando** acessar novamente o link de convite

**Então** não deve ser criada uma participação duplicada

### Cenário 5 — Check-in criado com sucesso

**Dado** que um usuário participe de um grupo ativo

**Quando** informar título, descrição, duração positiva e data/horário válidos

**Então** o check-in deve ser criado

**E** deve aparecer na timeline do grupo

**E** deve exibir o autor e a duração do estudo

### Cenário 6 — Usuário não participante tenta publicar

**Dado** que um usuário não participe de um grupo

**Quando** tentar criar um check-in nesse grupo

**Então** o sistema deve rejeitar a operação

**E** o check-in não deve ser criado

### Cenário 7 — Check-in inválido

**Dado** que o título esteja vazio ou que a duração seja menor ou igual a zero

**Quando** o usuário tentar publicar o check-in

**Então** o sistema deve rejeitar a operação

**E** deve informar quais dados precisam ser corrigidos

### Cenário 8 — Timeline cronológica

**Dado** que o grupo possua vários check-ins

**Quando** um participante acessar a timeline

**Então** os check-ins devem ser exibidos do mais recente para o mais antigo

## Definição de pronto

Esta especificação será considerada implementada quando:

- os fluxos principais puderem ser executados em uma aplicação local;
- as regras de validação estiverem implementadas;
- os critérios de aceitação tiverem testes ou verificações equivalentes;
- o grupo e os check-ins forem persistidos durante a execução da aplicação;
- existir uma interface mínima para demonstrar o fluxo completo;
- as decisões técnicas utilizadas estiverem registradas em `docs/decisoes-tecnicas.md`.

## Decisões relacionadas

- A stack inicial será Flutter com MVVM e Firebase.
- As fronteiras e restrições arquiteturais estão registradas em
  `docs/decisoes-tecnicas.md`.
- A primeira versão será direcionada para dispositivos mobile.
- O check-in poderá ser criado em qualquer horário, desde que o grupo ainda
  esteja ativo.
- Novos check-ins serão bloqueados após a data final do grupo.
- O link de convite terá validade de um dia.
- A classificação final ficará fora do primeiro incremento.
- O MVP utilizará exclusivamente cadastro e login com e-mail e senha.
- Login social ficará fora do MVP.

## Perguntas em aberto

- O fuso horário do check-in será o do usuário ou o do servidor?
- Como o sistema tratará diferenças de fuso horário entre participantes?
