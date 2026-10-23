# Especificação da feature: autenticação com Firebase

## Contexto

Esta feature transforma a especificação legada em um artefato por funcionalidade, seguindo o fluxo do GitHub Spec Kit. A especificação original permanece em [`../002-autenticacao-email-senha.md`](../002-autenticacao-email-senha.md) e continua sendo a referência funcional detalhada.

## Objetivo

Permitir cadastro, login, restauração de sessão e logout usando Firebase Authentication, com perfil de usuário persistido sem armazenar senha.

## Escopo

### Incluído

- Cadastro com nome, e-mail, senha, confirmação de senha e telefone opcional.
- Login com e-mail e senha.
- Logout.
- Restauração de sessão.
- Proteção da área autenticada.
- Perfil associado ao mesmo identificador da conta Firebase.
- Tratamento de credenciais inválidas, e-mail duplicado e indisponibilidade do Firebase.
- Testes unitários para domínio e testes com fakes para Repository e ViewModel.

### Não incluído

- Login social.
- Recuperação ou alteração de senha.
- Verificação de e-mail.
- Autenticação multifator.
- Exclusão ou edição de conta.

## Regras e invariantes

1. O domínio e a apresentação não podem depender do SDK do Firebase.
2. O SDK do Firebase só pode ser usado pelo `FirebaseAuthService` e pelos serviços de infraestrutura autorizados.
3. O `AuthRepository` coordena autenticação e persistência do perfil.
4. O identificador do perfil deve ser o mesmo identificador da conta autenticada.
5. A senha nunca pode ser armazenada no perfil, no Firestore ou em estado persistente do aplicativo.
6. Usuários não autenticados não podem acessar a área protegida.
7. Uma sessão válida deve ser restaurada na inicialização.

## Critérios de aceitação

- Cadastro válido cria uma conta no Firebase Authentication e um perfil correspondente.
- Login válido cria uma sessão e direciona para a área protegida.
- Logout encerra a sessão e direciona para a área pública.
- Sessão existente é restaurada na inicialização.
- Credenciais inválidas e e-mail já cadastrado produzem erros compreensíveis.
- Indisponibilidade do Firebase produz a mensagem definida na especificação original.
- Nenhum código de View ou ViewModel importa o Firebase.
- Testes automatizados cobrem as regras de validação, estados de carregamento, sucesso e erro.

## Referências

- [`constitution.md`](../../constitution.md)
- [`docs/decisoes-tecnicas.md`](../../docs/decisoes-tecnicas.md)
- [`../002-autenticacao-email-senha.md`](../002-autenticacao-email-senha.md)
