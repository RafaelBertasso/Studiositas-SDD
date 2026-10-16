# Decisões técnicas

As regras permanentes do projeto estão em `constitution.md`, na raiz do
repositório. Este documento registra apenas decisões técnicas específicas,
contextuais ou evolutivas.

## DEC-001 — Stack inicial e fronteiras arquiteturais

### Status

Aceita

### Contexto

O Studiositas precisa de uma primeira versão demonstrável para praticar
Spec-Driven Development, desenvolvimento incremental e uso do Codex como
agente de programação. A solução inicial deve reduzir a complexidade de
infraestrutura, mas preservar uma separação clara entre interface, regras de
negócio e persistência.

### Decisão

A primeira versão será desenvolvida com:

- Flutter para a aplicação;
- MVVM para a camada de apresentação;
- Firebase como infraestrutura inicial de dados e serviços;
- Repositories como fonte de acesso aos dados da aplicação;
- Services para encapsular as chamadas específicas do Firebase.

Posteriormente, será estudada uma implementação de backend em C# com Clean
Architecture. O banco de dados futuro poderá ser Supabase/PostgreSQL ou outra
alternativa adequada após uma nova avaliação.

### Regras arquiteturais obrigatórias

1. Widgets não podem acessar o Firebase.
2. Widgets não podem acessar Repositories ou Services diretamente.
3. Widgets não podem conter regras de negócio.
4. Widgets devem apenas apresentar estado, receber entrada do usuário e
   disparar comandos da ViewModel.
5. ViewModels não podem fazer chamadas de banco.
6. ViewModels não podem conhecer APIs específicas do Firebase.
7. ViewModels podem coordenar ações da interface e chamar casos de uso ou
   Repositories por meio de abstrações apropriadas.
8. Todas as chamadas de banco devem ocorrer nos Repositories ou na camada de
   Service utilizada exclusivamente pelos Repositories.
9. Services devem encapsular detalhes específicos do Firebase.
10. Repositories devem converter os dados da infraestrutura em modelos usados
    pela aplicação.
11. Regras de negócio devem ficar em uma camada de domínio ou aplicação, fora
    dos Widgets.
12. Critérios de aceitação devem ser escritos antes da implementação de cada
    funcionalidade.
13. Validações importantes devem possuir testes automatizados.
14. Decisões técnicas relevantes devem ser registradas neste documento.

### Fluxo permitido

```text
Widget/View
    ↓ eventos e estado
ViewModel
    ↓ comandos da aplicação
Use Case ou regra de aplicação
    ↓ contratos
Repository
    ↓ chamadas de persistência
Firebase Service
    ↓
Firebase
```

### Fluxos proibidos

```text
Widget/View ──────────────→ Firebase
Widget/View ──────────────→ Repository
ViewModel ─────────────────→ Firebase
ViewModel ─────────────────→ Firestore/Storage/Auth SDK
```

### Consequências positivas

- A interface fica independente do Firebase.
- As regras de negócio podem ser testadas sem widgets ou banco real.
- A implementação poderá ser substituída por uma API em C# no futuro.
- O projeto terá fronteiras claras para praticar SDD.
- A ViewModel permanece focada em estado e interação da interface.

### Consequências negativas

- Haverá mais classes e interfaces do que em uma implementação direta.
- O primeiro incremento exigirá disciplina para não colocar atalhos nas telas.
- Será necessário definir contratos entre domínio, repositories e services.
- A abstração só será útil se for acompanhada de testes e responsabilidades
  bem definidas.

### Critério para revisar esta decisão

Esta decisão poderá ser revisada quando o MVP estiver funcionando e houver
evidências de que:

- o Firebase está limitando consultas ou regras do produto;
- o domínio exige um backend próprio;
- é necessário oferecer a mesma API para múltiplos clientes;
- o objetivo de aprendizado passar a incluir Clean Architecture em C#.

## DEC-002 — Decisões funcionais do primeiro MVP

### Status

Aceita

### Decisões

- A primeira versão será direcionada para dispositivos mobile.
- O cadastro deverá utilizar autenticação real.
- O primeiro ciclo utilizará exclusivamente cadastro e login com e-mail e
  senha.
- Login social com Google ficará para uma etapa posterior.
- O cadastro poderá conter nome, e-mail, senha e telefone, mas o telefone não
  será obrigatório para o fluxo essencial até que exista uma regra de negócio
  que dependa dele.
- Um check-in poderá ser criado em qualquer horário do dia.
- Após a data final do grupo, novos check-ins deverão ser bloqueados.
- A classificação final dos grupos será implementada em uma etapa posterior.
- O link de convite terá validade de um dia.

