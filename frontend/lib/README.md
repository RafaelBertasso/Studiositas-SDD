# Estrutura da aplicação

Esta pasta segue a arquitetura definida em `constitution.md`.

```text
lib/
├── core/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── use_cases/
│   │   └── presentation/
│   │       ├── viewmodels/
│   │       └── views/
│   └── home/
│       └── presentation/
│           └── views/
└── shared/
```

## Responsabilidades

- `core/`: configurações e componentes fundamentais da aplicação.
- `features/`: organização por funcionalidade do produto.
- `data/`: implementações de acesso a dados e integração com infraestrutura.
- `domain/`: entidades, contratos e regras independentes do Firebase.
- `presentation/`: Views e ViewModels da funcionalidade.
- `shared/`: componentes compartilhados entre funcionalidades.

O Firebase deverá ser acessado somente por Services de infraestrutura usados
pelos Repositories. Views e ViewModels não podem importar o SDK do Firebase.
