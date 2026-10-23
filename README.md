# Studiositas

Rede social de estudos desenvolvida como um projeto prático de aprendizado
com agentes de IA e Spec-Driven Development (SDD).

## Objetivo

O Studiositas permitirá que pessoas criem grupos de estudos, convidem
participantes e compartilhem check-ins de estudo em uma timeline do grupo.

O projeto será desenvolvido de forma incremental, mantendo registros das
especificações, decisões técnicas, implementações e aprendizados.

## Estado atual

O projeto está na etapa inicial de preparação do MVP.

Já estão definidos:

- visão original do produto;
- especificação do MVP;
- autenticação com e-mail e senha;
- constituição com regras permanentes do projeto;
- estrutura inicial do aplicativo Flutter;
- validações de cadastro com testes unitários.

## Stack inicial

- Flutter;
- MVVM;
- Firebase;
- Repositories e Services para isolamento da infraestrutura;
- testes automatizados para regras de negócio.

O Firebase não será acessado diretamente pelas Views ou ViewModels. As regras
permanentes estão documentadas em [`constitution.md`](constitution.md).

## Estrutura do repositório

```text
.
├── constitution.md
├── docs/
├── specs/
└── frontend/
    ├── lib/
    ├── test/
    └── pubspec.yaml
```

## Documentação

- [Constituição do projeto](constitution.md)
- [Visão original](docs/visao-original.md)
- [Decisões técnicas](docs/decisoes-tecnicas.md)
- [Especificação do MVP](specs/001-mvp-grupos-e-checkins.md)
- [Especificação de autenticação](specs/002-autenticacao-email-senha.md)
- [Artefatos Spec Kit da autenticação](specs/002-autenticacao-email-senha/)

## Fluxo Spec Kit

As funcionalidades relevantes seguem o fluxo `spec.md → plan.md → tasks.md →
implementação → validação`. A constituição e as decisões técnicas existentes
continuam sendo referências do projeto; os artefatos por feature detalham como
cada etapa será executada.

## Desenvolvimento

Cada etapa deve ser desenvolvida em uma branch própria, criada a partir de
`main`. A branch deve conter apenas as alterações da etapa correspondente e
ser integrada à `main` após revisão e validação.
