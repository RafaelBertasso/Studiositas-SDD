# Studiositas — especificação 002: autenticação com e-mail e senha

## Status

Proposta

## Objetivo

Permitir que uma pessoa crie uma conta, entre no Studiositas com e-mail e
senha, permaneça autenticada durante o uso da aplicação e encerre sua sessão
com segurança.

## Escopo

### Incluído

- Tela de cadastro.
- Tela de login.
- Logout.
- Restauração da sessão autenticada ao reabrir a aplicação.
- Nome do usuário no cadastro.
- E-mail e senha gerenciados pelo Firebase Authentication.
- Telefone como campo opcional de perfil.
- Mensagens de validação para dados inválidos.
- Redirecionamento para a área autenticada após cadastro ou login.
- Redirecionamento para a área pública após logout.

### Não incluído

- Login social com Google.
- Login com outros provedores.
- Recuperação de senha.
- Verificação de e-mail.
- Autenticação multifator.
- Alteração de senha.
- Edição do perfil.
- Exclusão da conta.
- Permissões administrativas.

## Conceitos principais

### Conta de autenticação

Credencial gerenciada pelo Firebase Authentication.

Campos fornecidos pelo provedor:

- `id`
- `email`
- `created_at`

### Perfil do usuário

Dados de apresentação e identificação usados pelo Studiositas.

Campos mínimos:

- `id`
- `nome`
- `email`
- `telefone` opcional
- `criado_em`

O identificador do perfil deve corresponder ao identificador da conta de
autenticação. A senha não deve ser persistida em uma coleção ou documento do
aplicativo.

## Regras de negócio

1. O nome do usuário é obrigatório no cadastro.
2. O e-mail é obrigatório no cadastro e no login.
3. O e-mail deve ter formato válido.
4. A senha é obrigatória no cadastro e no login.
5. A senha deve ter no mínimo oito caracteres.
6. A senha deve conter pelo menos uma letra maiúscula, uma letra minúscula, um
   número e um caractere especial.
7. A confirmação de senha deve ser obrigatória e igual à senha informada.
8. O telefone é opcional no cadastro.
9. Um e-mail já cadastrado não pode criar uma segunda conta.
10. O cadastro deve criar uma conta de autenticação e um perfil de usuário.
11. O perfil deve usar o mesmo identificador da conta de autenticação.
12. Um usuário autenticado deve conseguir acessar a área protegida da
    aplicação.
13. Um usuário não autenticado não deve acessar a área protegida.
14. O logout deve encerrar a sessão local do usuário.
15. Após o logout, o usuário deve ser direcionado para a área pública.
16. Ao reabrir a aplicação, uma sessão válida deve ser restaurada.
17. A conta não precisa ter o e-mail confirmado para que o usuário entre em
    grupos por convite.
18. Se o Firebase estiver indisponível, a aplicação deve exibir a mensagem
    `Servidor Indisponível, tente novamente mais tarde ou contate o suporte.`
19. A senha nunca deve ser armazenada pelo aplicativo, pelo perfil ou em uma
    coleção do Firestore.

## Fronteiras arquiteturais

O fluxo de autenticação deve respeitar as regras permanentes definidas em
`constitution.md`:

```text
AuthView
    ↓ eventos e estado
AuthViewModel
    ↓ comandos
AuthRepository
    ↓ contrato de autenticação
FirebaseAuthService
    ↓
Firebase Authentication
```

O `AuthView` não pode importar ou utilizar o SDK do Firebase. A
`AuthViewModel` também não pode conhecer classes específicas do Firebase. O
`AuthRepository` deve ser a camada responsável por coordenar autenticação e
persistência do perfil, utilizando services encapsulados.

## Fluxos principais

### Fluxo 1 — Criar conta

1. A pessoa acessa a tela de cadastro.
2. Informa nome, e-mail, senha e, opcionalmente, telefone.
3. A ViewModel valida os dados de entrada.
4. O Repository solicita a criação da conta ao serviço de autenticação.
5. O sistema cria o perfil associado ao identificador da conta.
6. A pessoa é considerada autenticada.
7. A aplicação direciona a pessoa para a área protegida.

### Fluxo 2 — Entrar na aplicação

1. A pessoa acessa a tela de login.
2. Informa e-mail e senha.
3. A ViewModel valida os dados de entrada.
4. O Repository solicita a autenticação ao serviço.
5. O sistema confirma a sessão.
6. A aplicação direciona a pessoa para a área protegida.

### Fluxo 3 — Restaurar sessão

1. A aplicação é iniciada.
2. O sistema verifica se existe uma sessão válida.
3. Enquanto a verificação ocorre, a aplicação exibe um estado de carregamento.
4. Se houver sessão válida, a pessoa acessa a área protegida.
5. Se não houver sessão válida, a pessoa acessa a área pública.

### Fluxo 4 — Sair da aplicação

1. A pessoa autenticada solicita logout.
2. O Repository solicita o encerramento da sessão.
3. A sessão local é removida.
4. A aplicação direciona a pessoa para a área pública.

## Critérios de aceitação

### Cenário 1 — Cadastro realizado com sucesso

**Dado** que a pessoa informe nome, e-mail e senha válidos

**Quando** confirmar o cadastro

**Então** uma conta deve ser criada no Firebase Authentication

**E** um perfil deve ser criado com o mesmo identificador da conta

**E** a pessoa deve ser autenticada

**E** a aplicação deve exibir a área protegida

### Cenário 2 — Cadastro com telefone opcional

**Dado** que a pessoa informe nome, e-mail e senha válidos sem informar telefone

**Quando** confirmar o cadastro

**Então** a conta e o perfil devem ser criados com sucesso

**E** o telefone deve permanecer vazio ou nulo

### Cenário 3 — Senha válida com confirmação

**Dado** que a pessoa informe uma senha com pelo menos oito caracteres,
contendo letra maiúscula, letra minúscula, número e caractere especial

**E** informe a mesma senha no campo de confirmação

**Quando** confirmar o cadastro

**Então** o cadastro deve prosseguir para a criação da conta

### Cenário 4 — Senha fora do padrão

**Dado** que a senha tenha menos de oito caracteres ou não contenha um dos
requisitos obrigatórios

**Quando** a pessoa tentar confirmar o cadastro

**Então** o cadastro não deve ser enviado

**E** a aplicação deve informar os requisitos da senha

### Cenário 5 — Confirmação de senha diferente

**Dado** que a confirmação de senha seja diferente da senha informada

**Quando** a pessoa tentar confirmar o cadastro

**Então** o cadastro não deve ser enviado

**E** a aplicação deve informar que as senhas não coincidem

### Cenário 6 — E-mail já cadastrado

**Dado** que já exista uma conta com o e-mail informado

**Quando** a pessoa tentar criar uma nova conta com esse e-mail

**Então** o cadastro deve ser rejeitado

**E** nenhuma conta duplicada deve ser criada

**E** a aplicação deve informar que o e-mail já está em uso

### Cenário 7 — Dados obrigatórios ausentes

**Dado** que nome, e-mail ou senha esteja vazio

**Quando** a pessoa tentar confirmar o cadastro

**Então** o cadastro não deve ser enviado

**E** a aplicação deve indicar os campos que precisam ser preenchidos

### Cenário 8 — E-mail inválido

**Dado** que a pessoa informe um e-mail em formato inválido

**Quando** tentar confirmar o cadastro ou fazer login

**Então** a operação não deve ser enviada

**E** a aplicação deve informar que o e-mail é inválido

### Cenário 9 — Login realizado com sucesso

**Dado** que exista uma conta com o e-mail e a senha informados

**Quando** a pessoa confirmar o login

**Então** a sessão deve ser criada

**E** a aplicação deve exibir a área protegida

### Cenário 10 — Login com credenciais inválidas

**Dado** que o e-mail ou a senha não correspondam a uma conta válida

**Quando** a pessoa confirmar o login

**Então** a sessão não deve ser criada

**E** a aplicação deve permanecer na área pública

**E** deve exibir uma mensagem de erro apropriada

### Cenário 11 — Sessão restaurada

**Dado** que exista uma sessão válida salva no dispositivo

**Quando** a aplicação for reaberta

**Então** a pessoa deve permanecer autenticada

**E** deve acessar a área protegida após o carregamento inicial

### Cenário 12 — Sessão inexistente

**Dado** que não exista uma sessão válida

**Quando** a aplicação for iniciada

**Então** a pessoa deve permanecer na área pública

### Cenário 13 — Logout realizado

**Dado** que a pessoa esteja autenticada

**Quando** solicitar logout

**Então** a sessão deve ser encerrada

**E** a pessoa deve ser direcionada para a área pública

**E** não deve conseguir acessar diretamente a área protegida

### Cenário 14 — Entrada em grupo sem confirmação de e-mail

**Dado** que a pessoa esteja autenticada e possua um convite válido

**E** que o e-mail da conta ainda não tenha sido confirmado

**Quando** acessar o convite

**Então** a pessoa deve poder entrar no grupo

### Cenário 15 — Firebase indisponível

**Dado** que o Firebase esteja indisponível durante uma operação de
autenticação

**Quando** a operação falhar por indisponibilidade do serviço

**Então** a aplicação deve exibir a mensagem `Servidor Indisponível, tente
novamente mais tarde ou contate o suporte.`

### Cenário 16 — Senha não persistida pelo aplicativo

**Dado** que uma pessoa conclua o cadastro

**Quando** os dados forem persistidos

**Então** a senha não deve ser gravada no perfil do usuário

**E** não deve ser gravada em documentos do Firestore

## Testes obrigatórios

Devem existir testes para, no mínimo:

- validação de nome obrigatório;
- validação de e-mail obrigatório;
- validação de formato de e-mail;
- validação de senha obrigatória;
- validação de senha com oito caracteres e complexidade exigida;
- validação de confirmação de senha;
- aceitação de telefone vazio;
- rejeição de credenciais inválidas;
- tratamento de e-mail já cadastrado;
- transição de estado durante cadastro;
- transição de estado durante login;
- logout;
- restauração de sessão.
- tratamento de indisponibilidade do Firebase.

Os testes de ViewModel e domínio não devem depender do Firebase real. As
dependências devem ser substituídas por implementações falsas ou mocks.

## Definição de pronto

Esta especificação será considerada implementada quando:

- uma pessoa puder criar uma conta com e-mail e senha;
- o perfil for criado sem armazenar a senha;
- uma pessoa puder fazer login e logout;
- a sessão puder ser restaurada ao reabrir a aplicação;
- áreas protegidas forem inacessíveis sem autenticação;
- a View não tiver dependência direta do Firebase;
- a ViewModel não tiver dependência direta do Firebase;
- as chamadas de autenticação estiverem encapsuladas no Repository e nos
  Services;
- os testes obrigatórios estiverem implementados;
- os critérios de aceitação principais forem verificáveis localmente;
- as decisões técnicas utilizadas estiverem registradas.

## Perguntas em aberto

Não há perguntas funcionais pendentes nesta etapa.
