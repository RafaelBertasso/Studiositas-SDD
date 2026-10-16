# Studiositas — Constituição do projeto

Este documento contém as regras permanentes do projeto. Ele é a fonte de
verdade para decisões que devem ser respeitadas em todas as especificações,
implementações, revisões e alterações do Studiositas.

As regras deste documento só podem ser alteradas por meio de uma decisão
técnica registrada e revisada. Uma especificação de funcionalidade não deve
contradizer esta constituição sem registrar explicitamente a exceção e sua
justificativa.

## 1. Desenvolvimento orientado por especificação

1. Toda funcionalidade deve começar com uma especificação antes da escrita do
   código.
2. A especificação deve descrever objetivo, escopo, regras de negócio,
   critérios de aceitação e definição de pronto.
3. Os critérios de aceitação devem ser definidos antes da implementação.
4. O trabalho deve ser dividido em incrementos pequenos e demonstráveis.
5. Cada incremento deve ser validado antes do início do próximo.
6. Mudanças de escopo devem ser registradas na especificação ou em uma nova
   decisão técnica.
7. O código deve atender à especificação; a implementação não deve redefinir
   silenciosamente o comportamento esperado.

## 2. Stack e arquitetura inicial

1. A aplicação inicial será desenvolvida com Flutter.
2. A camada de apresentação seguirá MVVM.
3. O Firebase será utilizado como infraestrutura inicial.
4. O Firebase é um detalhe de infraestrutura substituível, não uma dependência
   da interface ou das regras de negócio.
5. A aplicação será inicialmente direcionada para dispositivos mobile.
6. Uma futura implementação de backend em C# com Clean Architecture será
   considerada em uma etapa posterior.

## 3. Fronteiras entre camadas

O fluxo padrão da aplicação deve seguir esta direção:

```text
View/Widget
    ↓ eventos e estado
ViewModel
    ↓ comandos da aplicação
Use Case ou camada de aplicação
    ↓ contratos
Repository
    ↓ chamadas de persistência
Firebase Service
    ↓
Firebase
```

### Views e Widgets

1. Widgets não podem acessar o Firebase.
2. Widgets não podem acessar Repositories ou Services diretamente.
3. Widgets não podem conter regras de negócio.
4. Widgets devem apenas apresentar estado, receber entrada do usuário e
   disparar comandos da ViewModel.
5. Widgets não devem decidir como os dados são buscados ou persistidos.

### ViewModels

1. ViewModels não podem fazer chamadas de banco.
2. ViewModels não podem importar ou conhecer APIs específicas do Firebase.
3. ViewModels devem coordenar estado da interface e comandos do usuário.
4. ViewModels devem depender de contratos ou abstrações, nunca de detalhes da
   infraestrutura.
5. ViewModels não devem duplicar regras de negócio pertencentes ao domínio ou
   à camada de aplicação.

### Domínio e aplicação

1. Regras de negócio devem ficar fora dos Widgets.
2. Regras que não dependem de interface ou Firebase devem ser testáveis de
   forma isolada.
3. Casos de uso devem ser criados quando uma operação possuir lógica relevante,
   combinar múltiplos Repositories ou precisar ser reutilizada.
4. O domínio não deve depender do SDK do Firebase.

### Repositories

1. Todas as chamadas de banco e persistência devem ser feitas nos
   Repositories ou nos Services utilizados exclusivamente por eles.
2. Repositories são a porta de entrada da aplicação para dados persistidos.
3. Repositories devem converter dados da infraestrutura em modelos usados pela
   aplicação.
4. Repositories não devem expor detalhes do Firebase para ViewModels ou Views.
5. Repositories devem possuir contratos que permitam testes com implementações
   falsas ou mocks.

### Firebase Services

1. Services devem encapsular chamadas específicas do Firebase.
2. O SDK do Firebase deve ficar isolado nos Services de infraestrutura.
3. Services não devem conter regras de apresentação.
4. Services não devem ser chamados diretamente por Views ou ViewModels.

## 4. Dados e segurança

1. Senhas nunca devem ser armazenadas pelo aplicativo, em perfis ou em
   documentos do Firestore.
2. A autenticação inicial será feita exclusivamente com e-mail e senha.
3. Login social ficará para uma etapa posterior.
4. Acesso a dados deve respeitar autenticação e autorização do usuário.
5. Regras de segurança do Firebase devem ser tratadas como parte da
   implementação da funcionalidade, não como configuração opcional.
6. Dados pessoais devem ser coletados somente quando houver necessidade para o
   produto ou para uma regra de negócio definida.

## 5. Testes e validação

1. Validações importantes devem possuir testes automatizados.
2. Regras de negócio devem ser testáveis sem widgets e sem conexão com o
   Firebase real.
3. Testes de ViewModel e domínio devem usar mocks, fakes ou stubs para
   substituir dependências externas.
4. Critérios de aceitação devem ser verificáveis por testes automatizados ou
   por uma verificação manual documentada.
5. Uma funcionalidade não está pronta apenas porque a tela funciona; suas
   regras, estados de erro e persistência também devem ser validados.

## 6. Registro de decisões e aprendizado

1. Decisões técnicas relevantes devem ser registradas em
   `docs/decisoes-tecnicas.md`.
2. Mudanças importantes de escopo devem ser refletidas nas specs.
3. Erros, descobertas e aprendizados relevantes devem ser registrados no
   diário de aprendizado quando esse artefato for criado.
4. Ao usar o Codex, o contexto da tarefa deve indicar a especificação e as
   regras da constituição relacionadas ao trabalho.

## 7. Checklist obrigatório para iniciar uma etapa

Antes de especificar ou codificar uma funcionalidade, verificar:

- [ ] `constitution.md` foi lido;
- [ ] existe uma spec para a funcionalidade;
- [ ] o escopo está definido;
- [ ] as regras de negócio estão definidas;
- [ ] os critérios de aceitação estão definidos;
- [ ] as fronteiras arquiteturais estão claras;
- [ ] os testes necessários foram identificados;
- [ ] perguntas que bloqueiam a implementação foram respondidas.

## 8. Fluxo de branches

1. Cada etapa de desenvolvimento deve começar em uma branch nova criada a
   partir da `main` atualizada.
2. A branch deve representar uma única etapa, funcionalidade ou alteração
   coerente.
3. O nome da branch deve indicar seu propósito, usando prefixos como
   `feature/`, `fix/`, `docs/`, `test/` ou `chore/`.
4. Commits devem ser pequenos, coerentes e descrever claramente a alteração
   realizada.
5. A branch deve ser enviada ao GitHub para preservar o histórico da etapa.
6. A `main` deve permanecer como a versão estável e integrável do projeto.
7. Uma etapa só deve ser integrada à `main` depois de suas validações e testes
   definidos na especificação.
8. Depois da integração, a próxima etapa deve criar uma nova branch a partir da
   `main` atualizada.

Exemplo de fluxo:

```text
main
  ↓ criar branch
feature/003-autenticacao
  ↓ implementar e testar
  ↓ commit e push
main ← integrar etapa validada
```

## 9. Hierarquia de referência

Em caso de dúvida, seguir esta ordem:

1. Constituição do projeto;
2. decisões técnicas aceitas;
3. especificação da funcionalidade;
4. implementação atual;
5. preferências locais de implementação.

Se houver conflito entre documentos, o conflito deve ser registrado e
resolvido antes de continuar a implementação.
